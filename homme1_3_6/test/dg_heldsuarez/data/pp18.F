!-------------------------------------------------------------------
! 07/05 R.Nair NCAR/SCD
! Interpolation of data onto standard lat/long grid (~T42)
! The source grid is equiangular (psi,eta,face,nlev+1) grid
!-------------------------------------------------------------------
     Program pp18
     Implicit None
     Integer, Parameter :: double=Selected_Real_Kind(p=14,r=100)
     Integer, Parameter :: ni=129, nj= 65, nl=18
     Real(Kind=double), Dimension(ni,nj,nl+1) :: flt
     Real(Kind=double), Dimension(nl) :: eta 
     Real(Kind=double), Dimension(nj,nl) :: vout 

       Real(Kind=double) :: zero,one,two
       Real(Kind=double) :: pi, twopi, pi2,pi4  , eps 

     Integer :: npp,nv,ne,nlev
     Integer :: nx, nel, nt, np , i,j,n  

     ! Read GLL pts from Homme 

     Open(unit=28,file='cs_geometry.dat')

      print*,   'pp18.F  post-processing'
      read(28,*) npp,nv,ne,nlev
      print*,   'nv,ne,nlev: ', nv,ne,nlev
      print*,   'Out file: dglatlong.dat '

      nx = nv
      nel = ne
      nt = (nx-1)*nel 
      np = nx * nel

       if (nlev /= nl) print*, 'Vertical Dimension error', nlev, nl 


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

          flt = 0.0D0
     
     Call  Eta_Cord(eta)

     Call  Cube2Sphere_dat(eta,flt,vout)


   ! Visual data
   !  Open (unit = 40, file = 'dg3dll.dat')
   !     Write(40,3) (((flt(i,j,n),i=1,ni),j=1,nj),n=1,nl)
   !  Close(40)
     !3     format(5f18.5)
      3     format(5E18.6)

     Open (unit = 43, file = 'u3d_yz.dat')
        Write(43,3) ((vout(j,n),j=1,nj),n=1,nl)
     Close(43)

     Open (unit = 48, file = 'ps.dat')
        Write(48,3) ((flt(i,j,nl+1),i=1,ni),j=1,nj)
     Close(48)

    Open (unit = 58, file = 't850.dat')
       Write(58,3) ((flt(i,j,nl-4),i=1,ni),j=1,nj)
    Close(58)

   !  Open (unit = 45, file = 'eta26.dat')
   !     Write(45,*) (eta(n),n=1,nl)
   !  Close(45)

  Contains

  !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Subroutine  Cube2Sphere_dat(et,flt,vs_out)

     Real(Kind=double), Intent(in), Dimension(nl) :: et
     Real(Kind=double), Intent(out), Dimension(ni,nj,nl+1) :: flt
     Real(Kind=double), Intent(out), Dimension(nj,nl):: vs_out

     Real(Kind=double), Dimension(nj,nl):: vslice
     Real(Kind=double), Dimension(np,np,6,nl+1):: fin   

     Real(Kind=double), Dimension(ni,nj,2) :: sph_ll
     Real(Kind=double), Dimension(nx) :: gl  
     Real(Kind=double), Dimension(nel+1) :: gp  
     Real(Kind=double), Dimension(nt+1) :: xoy 
     Real(Kind=double), Dimension(np) :: mgll
     Real(Kind=double), Dimension(4) :: y4       

     Real(Kind=double), Dimension(ni) :: lam
     Real(Kind=double), Dimension(nj) :: the
     Real(Kind=double), Dimension(nl) :: etg

     Integer, Dimension(ni,nj) :: iface      

       Real(Kind=double) :: lm,th, psi,eta, dla,dth 
       Real(Kind=double) :: aa, r3,xx,yy,zz,pm, val
       Real(Kind=double) :: x1,x2,y1,y2,xin, f1,f2 

      Integer :: i,j,k,l,ip,  kj,n, n1,n2, ix,iy,iz, ik
      Integer :: indx_sph(ni,nj,2)

      Open(unit=30,file='gllpts.dat')

      Open(unit=32,file='dat3d.out')

      read(30,*)(gl(j),j=1,nx)
      read(32,*)((((fin(i,j,k,l),i=1,np),j=1,np),k=1,6),l=1,nl+1)

      Close(30)
      Close(32)


      ! do k = 1, nx
      !  print*, k, gl(k)
      ! enddo

        
       do k = 1, nl
         etg(k) = (1.0D0 / dble(nl-1))* (k-1)
         !print*, et(k),etg(k)
       enddo

       
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
         !print*, kj, mgll(kj)
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

       ! Index for traget grid (lat/lon sphere)
 
         do i = 1, ni-1
         do j = 1, nj

            ip = iface(i,j)
            lm = lam(i)
            th = the(j)

          Call Face_Point(mgll,ip,lm,th,psi,eta,ix,iy)

             indx_sph(i,j,1) = ix
             indx_sph(i,j,2) = iy
             sph_ll(i,j,1) = psi
             sph_ll(i,j,2) = eta
         enddo
         enddo

      !Data interpolation onto long/lat grid (lambda,theta)
      ! Source grid is the "monotonized GLL grid"  on every face

        do n = 1, nl + 1

         print*, 'Num. of  V-levels:', n 

         do i = 1, ni-1
         do j = 1, nj

            ip = iface(i,j)
            lm = lam(i)
            th = the(j)

            ix = indx_sph(i,j,1)
            iy = indx_sph(i,j,2)
            psi = sph_ll(i,j,1)
            eta = sph_ll(i,j,2)

           y4(1) = fin(ix,iy,    ip,n)
           y4(2) = fin(ix+1,iy,  ip,n)
           y4(3) = fin(ix+1,iy+1,ip,n)
           y4(4) = fin(ix,iy+1,  ip,n)

              !!tensor-product liner interpolation
              ! x1 = mgll(ix)
              ! x2 = mgll(ix+1)
              ! y1 = y4(1)        
              ! y2 = y4(2)          
              !  f1 = Linear_Int(x1,x2,y1,y2,psi)
              ! y1 = y4(4)        
              ! y2 = y4(3)          
              !  f2 = Linear_Int(x1,x2,y1,y2,psi)
              ! x1 = mgll(iy)
              ! x2 = mgll(iy+1)
              ! val = Linear_Int(x1,x2,f1,f2,eta)

          Call Bilinear_Intp(mgll,psi,eta,ix,iy,y4,val)

          flt(i,j,n) = val 

        !     if  (n > nl) then
        !       if (val  < 1.0D0 )  print*, i,j, val
        !     endif 


         enddo
         enddo

      enddo 

     !     !Periodic continuity

           do k = 1, nl+1  
           do j = 1, nj    
             flt(ni,j,k) = flt(1,j,k)
           enddo
           enddo

      ! Vertical interpolations to regular eta levels for a zonal slice

           do k = 1, nl  
           do j = 1, nj    
             vslice(j,k) = flt(70,j,k)
           enddo
           enddo

           vs_out(:,1) =  vslice(:,1)
           vs_out(:,nl) =  vslice(:,nl)

           do j = 1, nj
             do k = 2, nl-1
                
                xin = etg(k)

                ik = Indx_bisect(et,xin)

                x1 = et(ik)
                x2 = et(ik+1)
                y1 = vslice(j,ik)
                y2 = vslice(j,ik+1)

              vs_out(j,k) = Linear_Int(x1,x2,y1,y2,xin)
                
             enddo        
            enddo        

 
      end  subroutine Cube2Sphere_dat

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        Function Indx_bisect(grid,xp) result(ii)

        Implicit None
          Real(Kind=double), Intent(in) :: xp
          Real(Kind=double), Intent(in), Dimension(nl):: grid
          Integer  :: ii, nm,na,nb
            na = 1
            nb = nl
             do
               if  ((nb-na) <=  1)  exit
               nm = (nb + na)/2
                if (xp  >  grid(nm)) then
                 na = nm
                else
                 nb = nm
                endif
             enddo

              ii = na

       end Function Indx_bisect

 !-----------------------------------------------------------


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
! Linear interpolation

      Function  Linear_Int(x1,x2,y1,y2,xin)  result(yout)

      Implicit None
      Real(Kind=double), Intent(in) :: x1,x2,y1,y2 ,xin

      Real(Kind=double) :: ss, yout

          if (x2 == x1)  then
               yout = y1
            else
                ss = (y2 - y1)/(x2 - x1)
                  yout = y1 + ss * (xin - x1)
          endif

      end    Function Linear_Int

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

          val = (1.0D0 - p)*(1.0D0 - q)* y4(1) + p*(1.0D0 - q) * y4(2)   &
                              + p*q* y4(3) + (1.0D0 - p)*q * y4(4)

         end  Subroutine Bilinear_Intp

!-----------------------------------------------------------------

      Subroutine Eta_cord(etac)

         Real(Kind=double), Intent(out), Dimension(nl) :: etac   

    real (kind=double) :: a18(18+1) = &
    (/ 0.00251499D0,  0.00710361D0,  0.01904260D0, 0.04607560D0, 0.08181860D0, &
       0.07869805D0,  0.07463175D0,  0.06955308D0, 0.06339061D0, 0.05621774D0, &
       0.04815296D0,  0.03949230D0,  0.03058456D0, 0.02193336D0, 0.01403670D0, &
       0.007458598D0, 0.002646866D0, 0.00000000D0, 0.00000000D0  /)

    real (kind=double) :: b18(18+1) = &
    (/ 0.000000D0,   0.000000D0,   0.000000D0,  0.000000D0,  0.000000D0, &
       0.03756984D0, 0.08652625D0, 0.1476709D0, 0.221864D0,  0.308222D0, &
       0.4053179D0,  0.509588D0,   0.6168328D0, 0.7209891D0, 0.816061D0, &
       0.8952581D0,  0.953189D0,   0.985056D0,  1.000000D0   /)


    real (kind=double) :: a26(26+1) = &
    (/ 0.002194067D0, 0.004895209D0, 0.009882418D0, 0.01805201D0, 0.02983724D0, &
       0.04462334D0,  0.06160587D0,  0.07851243D0,  0.07731271D0, 0.07590131D0, &
       0.07424086D0,  0.07228744D0,  0.06998933D0,  0.06728574D0, 0.06410509D0, &
       0.06036322D0,  0.05596111D0,  0.05078225D0,  0.04468960D0, 0.03752191D0, &
       0.02908949D0,  0.02084739D0,  0.01334443D0,  0.00708499D0, 0.00252136D0, &
       0.00000000D0,  0.00000000D0  /)
 
    real (kind=double) :: b26(26+1) = &
     (/ 0.00000000D0, 0.00000000D0, 0.00000000D0, 0.00000000D0, 0.00000000D0, &
        0.00000000D0, 0.00000000D0, 0.00000000D0, 0.01505309D0, 0.03276228D0, &
        0.05359622D0, 0.07810627D0, 0.1069411D0,  0.1408637D0,  0.1807720D0,  &
        0.2277220D0,  0.2829562D0,  0.3479364D0,  0.4243822D0,  0.5143168D0,  &
        0.6201202D0,  0.7235355D0,  0.8176768D0,  0.8962153D0,  0.9534761D0,  &
        0.9851122D0,  1.0000000D0  /)



   !    real (kind=double) :: ak(nl+1) = &
   !    (/ 0.002194067D0, 0.004895209D0, 0.009882418D0, 0.01805201D0, 0.02983724D0, &
   !       0.04462334D0,  0.06160587D0,  0.07851243D0,  0.07731271D0, 0.07590131D0, &
   !       0.07424086D0,  0.07228744D0,  0.06998933D0,  0.06728574D0, 0.06410509D0, &
   !       0.06036322D0,  0.05596111D0,  0.05078225D0,  0.04468960D0, 0.03752191D0, &
   !       0.02908949D0,  0.02084739D0,  0.01334443D0,  0.00708499D0, 0.00252136D0, &
   !       0.00000000D0,  0.00000000D0  /)
   !    real (kind=double) :: bk(nl+1) = &
   !     (/ 0.00000000D0, 0.00000000D0, 0.00000000D0, 0.00000000D0, 0.00000000D0, &
   !        0.00000000D0, 0.00000000D0, 0.00000000D0, 0.01505309D0, 0.03276228D0, &
   !        0.05359622D0, 0.07810627D0, 0.1069411D0,  0.1408637D0,  0.1807720D0,  &
   !        0.2277220D0,  0.2829562D0,  0.3479364D0,  0.4243822D0,  0.5143168D0,  &
   !        0.6201202D0,  0.7235355D0,  0.8176768D0,  0.8962153D0,  0.9534761D0,  &
   !        0.9851122D0,  1.0000000D0  /)

          Real(Kind=double), dimension(nl+1) :: et   , ak, bk 
          Integer :: k 

   if (nl == 18 ) then
       do k = 1, nl+1
          ak(k)= a18(k)
          bk(k)= b18(k)
       end do
    elseif (nl == 26) then
       do k = 1, nl+1
          ak(k)= a26(k)
          bk(k)= b26(k)
       end do
    endif



         do k = 1, nl+1
            et(k) = ak(k) + bk(k)
         end do

         do k = 1, nl
            etac(k) = (et(k) + et(k+1)) * 0.5D0
         end do

         end  Subroutine Eta_cord

     End  Program pp18

