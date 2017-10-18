#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

program test_mesh_mod

  use parallel_mod, only : parallel_t,  initmp, haltmp, syncmp, iam
  use control_mod, only : MAX_FILE_LEN
  use dimensions_mod, only : nelem
  use element_mod, only : element_t
  use gridgraph_mod, only : gridvertex_t, gridedge_t

  use mesh_mod

  implicit none
  
  integer :: numarg
  character (MAX_FILE_LEN) arg

  integer :: nelem_edge,nedge

  type (parallel_t) :: par  ! parallel structure for distributed memory programming
  type (GridVertex_t), target,allocatable :: GridVertex(:)
  type (GridEdge_t),   target,allocatable :: Gridedge(:)
  type (element_t), pointer :: elem(:)
  
  numarg = iargc()

  if (numarg /= 1) then
     print *, 'please give only one argument, which is the name of the mesh file'
     stop
  endif

  call getarg (1, arg)

  par=initmp()
  print *, 'Starting test for mesh_mod', iam
  ! Hold everyone so messages are in order
  call syncmp(par)
  
  MeshUseMeshFile = .true.

  call MeshOpen(arg, par)
  call MeshPrint(par)
  !call test_private_methods()

  nelem      = MeshCubeElemCount()
  nelem_edge = MeshCubeEdgeCount()

  print *, 'Number of Elements ' , nelem
  print *, 'Number of Element Edges ',  nelem_edge

  allocate(GridVertex(nelem))
  allocate(GridEdge(nelem_edge))

  print *, 'Process ', iam, 'trying to run  MeshCubeTopology...'
  call syncmp(par)
  call MeshCubeTopology(GridEdge,GridVertex)
  print *, 'Process ', iam,'OK'
  call syncmp(par)

  allocate(elem(nelem))
  print *, 'Process ', iam, 'trying to run  MeshSetCoordinates...'
  call syncmp(par)
  call MeshSetCoordinates(elem)
  print *, 'Process ', iam,'OK'
  call syncmp(par)
  
  deallocate(GridVertex)
  deallocate(Gridedge)
  deallocate(elem)

  call MeshClose()
  
  call haltmp("exiting program...")
end program test_mesh_mod
