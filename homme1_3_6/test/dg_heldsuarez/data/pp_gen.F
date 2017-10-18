!-------------------------------------------------------------------
! 07/05 R.Nair NCAR/SCD
! Interpolation of data onto standard lat/long grid (~T42)
! The source grid is equiangular (psi,eta) grid
!-------------------------------------------------------------------
     Program pp_gen
     Implicit None
     Integer, Parameter :: double=Selected_Real_Kind(p=14,r=100)
     Integer, Parameter :: ni=129, nj= 65
     Real(Kind=double), Dimension(ni,nj) :: flt

       Real(Kind=double) :: zero,one,two
       Real(Kind=double) :: pi, twopi, pi2,pi4  , eps 

     Integer :: npp,nv,ne,nlev
     Integer :: nx, nel, nt, np , i,j 

     ! Read GLL pts from Homme 

     Open(unit=28,file='cs_geometry.dat')

      print*,   'pp_gen.F  post-processing'
      read(28,*) npp,nv,ne,nlev
      print*,   'nv,ne,nlev: ', nv,ne,nlev
      print*,   'Out file: dglatlong.dat '

      nx = nv
      nel = ne
      nt = (nx-1)*nel 
      np = nx * nel

        !Basic Constants

            zero = 0.0_double
             one = 1.0_double
             two = 2.0_double
             eps = 1.0D-09       

              pi = acos(zero)*two
           twopi = pi * two
             pi2 = pi / two
             pi4 = pi/dble(4)

     ! Post-processed file 

     Call  Cube2Sphere_dat(flt)

     ! Visual data
      Open (unit = 40, file = 'dglatlong.dat')
         Write(40,3) ((flt(i,j),i=1,ni),j=1,nj)
      3     format(2x,5f15.6)
      Close(40)


  Contains

  !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

     Subroutine  Cube2Sphere_dat(flt)

     Real(Kind=double), Intent(out), Dimension(ni,nj) :: flt

     Real(Kind=double), Dimension(np,np,6):: fin   
     Real(Kind=double), Dimension(nx,nx,nel,nel,6) :: fel

     Real(Kind=double), Dimension(nt+1,nt+1,6) :: fxy
     Real(Kind=double), Dimension(nx) :: gl  
     Real(Kind=double), Dimension(nel+1) :: gp  
     Real(Kind=double), Dimension(nt+1) :: xoy 
     Real(Kind=double), Dimension(np) :: mgll
     Real(Kind=double), Dimension(4) :: y4       

     Real(Kind=double), Dimension(ni) :: lam
     Real(Kind=double), Dimension(nj) :: the

     Integer, Dimension(ni,nj) :: iface      

       Real(Kind=double) :: lm,th, psi,eta, dla,dth 
       Real(Kind=double) :: aa, r3,xx,yy,zz,pm, val

      Integer :: i,j,k,l,ip,  kj,n, n1,n2, ix,iy,iz

      Open(unit=30,file='gllpts.dat')
      Open(unit=32,file='psi.out')

      read(30,*)(gl(j),j=1,nx)
      read(32,*)(((fin(i,j,k),i=1,np),j=1,np),k=1,6)

      Close(30)
      Close(32)


      ! do k = 1, nx
      !  print*, k, gl(k)
      ! enddo

       
      ! Equi-angular grid  in [-pi4, pi4]

          do k = 1, nel+1
            gp(k) = -pi4 + (pi/dble(2*nel)) * (k-1) 
          enddo
             
      ! Equi-angular grid in (xi,eta)-space (1D independent points),
      ! Interpolation is performrd on this grid (x or y direction)

          do k = 1, nel
           do j = 1, nx-1
              kj = (k-1)*(nx-1) + j
               xoy(kj) = (gp(k) + gp(k+1) + (gp(k+1) - gp(k)) *gl(j) )/two
           enddo

           do j = 1, nx
              kj = (k-1)*nx + j
               mgll(kj) = (gp(k) + gp(k+1) + (gp(k+1) - gp(k)) *gl(j) )/two
           enddo
          enddo
               xoy(nt+1) = gp(nel+1)

      ! Monotonize "mgll" GLL grid  (adding epsilon to repeated values)

         do kj = 1, np
          if ((kj > nx-1) .and. (mod(kj,nx) == 0) .and. (kj < np) ) then
             mgll(kj) = mgll(kj) - eps
          endif
       !  print*, kj, mgll(kj)
         enddo
            


      ! Target grid (ni x nj)   (Poles included) generation
 
          dla = twopi /dble(ni-1)
          dth = pi / dble(nj-1)
 
          do i = 1, ni
           lam(i)= dla * dble(i-1)
          enddo
 
          do j = 1, nj
           the(j)= dth * dble(j-1) - pi2
          enddo

     ! Position of the Target grid On Cube Faces

         do i = 1, ni
         do j = 1, nj

             xx  = cos(lam(i))*cos(the(j))
             yy  = sin(lam(i))*cos(the(j))
             zz  = sin(the(j))

              pm = max(abs(xx),abs(yy),abs(zz))

             Call Integer_Part(xx,pm,ix)
             Call Integer_Part(yy,pm,iy)
             Call Integer_Part(zz,pm,iz)


 ! For Homme grids

             if (iz  ==  1) then
                iface(i,j) = 6
               elseif (iz  == -1) then
                  iface(i,j) = 5
                 elseif ((ix == 1).and.(iy /= 1)) then
                     iface(i,j) = 1
                   elseif ((ix == -1).and.(iy /= -1)) then
                     iface(i,j) = 3
                 elseif ((iy == 1).and.(ix /= -1)) then
                   iface(i,j) = 2
               elseif ((iy == -1).and.(ix /=  1)) then
                iface(i,j) = 4
             endif

            ip = iface(i,j) 

         enddo
         enddo
 

      !Data interpolation onto long/lat grid (lambda,theta)
      ! Source grid is the "monotonized GLL grid"  on every face

         do i = 1, ni-1
         do j = 1, nj

            ip = iface(i,j)
            lm = lam(i)
            th = the(j)

          Call Face_Point(mgll,ip,lm,th,psi,eta,ix,iy)

           y4(1) = fin(ix,iy,ip)
           y4(2) = fin(ix+1,iy,ip)
           y4(3) = fin(ix+1,iy+1,ip)
           y4(4) = fin(ix,iy+1,ip)

          Call Bilinear_Intp(mgll,psi,eta,ix,iy,y4,val)

          flt(i,j) = val 

         enddo
         enddo

           flt(ni,:) = flt(1,:)              !Periodic continuity
 
      end  subroutine Cube2Sphere_dat

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


       Subroutine Face_Point(mgll,nf,xl,yt,xp,yp,ii,jj)

        !Gives the index (ii,jj) for the point (xl,yt) on face "nf"
        !  and correspoding cube-face (local) coordinates (xp,yp) 

         Integer, Intent(in) :: nf
         Integer, Intent(out) :: ii,jj
         Real(Kind=double), Intent(in), Dimension(np) :: mgll   
         Real(Kind=double), Intent(in) :: xl,yt
         Real(Kind=double), Intent(out) :: xp,yp

         Integer :: na,nb,nm 

            if (nf  == 1) then

               if (xl >= (twopi - pi4)) xp = xl - twopi
               if (xl <=  pi4) xp = xl 

              yp = atan(tan(yt)/cos(xp))

            elseif  (nf == 2) then
              xp = xl - pi2
              yp = atan(tan(yt)/cos(xp))

            elseif  (nf == 3) then
              xp = xl - pi
              yp = atan(tan(yt)/cos(xp))

            elseif  (nf == 4) then
              xp = xl - pi *1.5_double
              yp = atan(tan(yt)/cos(xp))

            elseif  (nf == 6) then
              xp = atan(sin(xl)/tan(yt))
              yp = atan(-cos(xl)/tan(yt))

            elseif  (nf == 5) then
              xp = atan(-sin(xl)/tan(yt))
              yp = atan(-cos(xl)/tan(yt))
            endif

     ! Searching the position of (xp,yp) on [ax,ay] grid (Bisection)
     ! Searching the position of (xp,yp) on monotonic GLL grids         

         !  Along ax

            na = 1
            !nb = nt+1
            nb = nx*nel        
             do
               if  ((nb-na) <=  1)  exit
               nm = (nb + na)/2
                   !if (xp  >  xoy(nm)) then
                if (xp  >  mgll(nm)) then
                 na = nm
                else
                 nb = nm
                endif
             enddo
              ii = na

         !  Along ay

            na = 1
            !nb = nt+1
            nb = nx*nel       
             do
               if  ((nb-na) <=  1)  exit
               nm = (nb + na)/2
                   !if (yp  >  xoy(nm)) then
                if (yp  >  mgll(nm)) then
                 na = nm
                else
                 nb = nm
                endif
             enddo
              jj = na

         end Subroutine Face_Point
        
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           
       Subroutine Integer_part(a,b,ii)

         Integer, Intent(out) :: ii
          Real(Kind=double), Intent(in) :: a,b   
          Real(Kind=double) :: tol,a1,b1 
         
            tol = 1.0e-12_double
       
             a1 = abs(a)
             b1 = abs((b - a1)/b)

             if (b1 < tol )  then
                if (a < zero)  then
                   ii = -1 
                 else
                   ii =  1 
                endif 
              else
                ii = int(a/b)
             endif 

         end  Subroutine Integer_Part

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

       Subroutine Bilinear_Intp(mgll,xp,yp,ii,jj,y4,val)

         !Bilinear interpolation on source grid [xoy X xoy]

         Integer, Intent(in) :: ii,jj
          Real(Kind=double), Intent(in), Dimension(np) :: mgll   
          Real(Kind=double), Intent(in) :: xp,yp  
          Real(Kind=double), Intent(in), Dimension(4) :: y4   
          Real(Kind=double), Intent(out) :: val    

          Real(Kind=double) :: p,q       
         
           !  p = (xp - xoy(ii))/(xoy(ii+1) - xoy(ii))
           !  q = (yp - xoy(jj))/(xoy(jj+1) - xoy(jj))

              p = (xp - mgll(ii))/(mgll(ii+1) - mgll(ii))
              q = (yp - mgll(jj))/(mgll(jj+1) - mgll(jj))

          val = (one - p)*(one - q)* y4(1) + p*(one - q) * y4(2)   &
                              + p*q* y4(3) + (one - p)*q * y4(4)

         end  Subroutine Bilinear_Intp

     End  Program pp_gen

