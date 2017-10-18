  !
  ! Dimension routines:
  !
  ! -----------
  function nf90_def_dim(ncid, name, len, dimid)
    integer,             intent( in) :: ncid
    character (len = *), intent( in) :: name
    integer,             intent( in) :: len
    integer,             intent(out) :: dimid
    integer                          :: nf90_def_dim
  
    nf90_def_dim = -1
  end function nf90_def_dim
  ! -----------
  function nf90_inq_dimid(ncid, name, dimid)
    integer,             intent( in) :: ncid
    character (len = *), intent( in) :: name
    integer,             intent(out) :: dimid
    integer                          :: nf90_inq_dimid
    
    nf90_inq_dimid = -1
  end function nf90_inq_dimid
  ! -----------
  function nf90_rename_dim(ncid, dimid, name)
    integer,             intent( in) :: ncid
    character (len = *), intent( in) :: name
    integer,             intent( in) :: dimid
    integer                          :: nf90_rename_dim

    nf90_rename_dim = -1
  end function nf90_rename_dim
  ! -----------
  function nf90_Inquire_Dimension(ncid, dimid, name, len)
    integer,                       intent( in) :: ncid, dimid
    character (len = *), optional, intent(out) :: name
    integer,             optional, intent(out) :: len
    integer                                    :: nf90_Inquire_Dimension
    
    character (len = nf90_max_name) :: dimName
    integer                         :: length
    
    nf90_Inquire_Dimension = -1
    if(present(name)) name = trim(dimName)
    if(present(len )) len  = length
  end function nf90_Inquire_Dimension
  ! -----------
