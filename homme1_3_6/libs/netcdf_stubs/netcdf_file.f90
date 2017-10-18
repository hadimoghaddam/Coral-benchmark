  ! -------
  function nf90_inq_libvers()
    character(len = 80) :: nf90_inq_libvers
    
    nf90_inq_libvers = ''
  end function nf90_inq_libvers
  ! -------
  function nf90_strerror(ncerr)
    integer, intent( in) :: ncerr
    character(len = 80)  :: nf90_strerror
    
    nf90_strerror = 'STUBS LIBRARY LOADED'
  end function nf90_strerror
  ! -------
  !
  ! File level control routines:
  !
  function nf90_inq_base_pe(ncid, pe)
    integer, intent( in) :: ncid
    integer, intent(out) :: pe
    integer              :: nf90_inq_base_pe

    nf90_inq_base_pe = -1
  end function nf90_inq_base_pe
  ! -------
  function nf90_set_base_pe(ncid, pe)
    integer, intent( in) :: ncid, pe
    integer              :: nf90_set_base_pe
  
    nf90_set_base_pe = -1 
  end function nf90_set_base_pe
  ! -------
  function nf90_create(path, cmode, ncid, initialsize, chunksize)
    character (len = *), intent(in   ) :: path
    integer,             intent(in   ) :: cmode
    integer,             intent(  out) :: ncid
    integer, optional,   intent(in   ) :: initialsize
    integer, optional,   intent(inout) :: chunksize
    integer                            :: nf90_create
    
    integer :: fileSize, chunk
    
    if(.not. (present(initialsize) .or. present(chunksize)) ) then
      nf90_create = -1 
    else
      ! Default values per man page
      filesize = 0; chunk = nf90_sizehint_default
      if(present(initialsize)) filesize = initialsize
      if(present(chunksize  )) chunk    = chunksize
      nf90_create = -1
      ! Pass back the value actually used
      if(present(chunksize  )) chunksize = chunk
    end if
  end function nf90_create
  ! -------
  function nf90_create_mp(path, cmode, initalsz, basepe, chunksizehint, ncid)
    character (len = *), intent( in) :: path
    integer,             intent( in) :: cmode, initalsz, basepe, chunksizehint
    integer,             intent(out) :: ncid
    integer                          :: nf90_create_mp
    
    nf90_create_mp = -1
  end function nf90_create_mp
  ! -------
  function nf90_open(path, mode, ncid, chunksize)
    character (len = *), intent(in   ) :: path
    integer,             intent(in   ) :: mode
    integer,             intent(  out) :: ncid
    integer, optional,   intent(inout) :: chunksize
    integer                            :: nf90_open

    if(present(chunksize)) then
      nf90_open = -1
    else
      nf90_open = -1
    end if
  end function nf90_open
  ! -------
  function nf90_open_mp(path, mode, basepe, chunksizeint, ncid)
    character (len = *), intent( in) :: path
    integer,             intent( in) :: mode, basepe, chunksizeint
    integer,             intent(out) :: ncid
    integer                          :: nf90_open_mp
    
    nf90_open_mp = -1
  end function nf90_open_mp
  ! -------
  function nf90_set_fill(ncid, fillmode, old_mode)
    integer, intent( in) :: ncid, fillmode 
    integer, intent(out) :: old_mode
    integer              :: nf90_set_fill
  
    nf90_set_fill = -1
  end function nf90_set_fill
  ! -------
  function nf90_redef(ncid)
    integer, intent( in) :: ncid
    integer              :: nf90_redef
  
    nf90_redef = -1
  end function nf90_redef
   ! -------
  function nf90_enddef(ncid, h_minfree, v_align, v_minfree, r_align)
    integer,           intent( in) :: ncid
    integer, optional, intent( in) :: h_minfree, v_align, v_minfree, r_align
    integer                        :: nf90_enddef
    
    integer :: hMinFree, VAlign, VMinFree, RAlign
    
    if(.not. any( (/ present(h_minfree), present(v_align), &
                     present(v_minfree), present(r_align) /) ) )then
      nf90_enddef =-1
    else 
      ! Default values per the man page
      hMinFree = 0; VMinFree = 0
      VAlign   = 4; RAlign   = 4
      if(present(h_minfree)) HMinFree = h_minfree
      if(present(v_align  )) VAlign   = v_align
      if(present(v_minfree)) VMinFree = v_minfree
      if(present(r_align  )) RAlign   = r_align
      nf90_enddef = -1
    end if
  end function nf90_enddef
  ! -------
  function nf90_sync(ncid)
    integer, intent( in) :: ncid
    integer              :: nf90_sync
  
    nf90_sync = -1
  end function nf90_sync
  ! -------
  function nf90_abort(ncid)
    integer, intent( in) :: ncid
    integer              :: nf90_abort
  
    nf90_abort = -1
  end function nf90_abort
  ! -------
  function nf90_close(ncid)
    integer, intent( in) :: ncid
    integer              :: nf90_close
  
    nf90_close = -1
  end function nf90_close
  ! -------
  function nf90_delete(name)
    character(len = *), intent( in) :: name
    integer                         :: nf90_delete
  
    nf90_delete = -1
  end function nf90_delete
   
  !
  ! A single file level inquiry routine 
  ! 
  function nf90_Inquire(ncid, nDimensions, nVariables, nAttributes, unlimitedDimId)
    integer,           intent( in) :: ncid
    integer, optional, intent(out) :: nDimensions, nVariables, nAttributes, unlimitedDimId
    integer                        :: nf90_Inquire
    
    integer :: nDims, nVars, nGAtts, unlimDimId
    
    nf90_Inquire = -1
    if(present(nDimensions))    nDimensions    = nDims 
    if(present(nVariables))     nVariables     = nVars
    if(present(nAttributes))    nAttributes    = nGAtts
    if(present(unlimitedDimId)) unlimitedDimId = unlimDimId
  end function nf90_Inquire

  
