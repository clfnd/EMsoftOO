! ###################################################################
! Copyright (c) 2013-2021, Marc De Graef Research Group/Carnegie Mellon University
! All rights reserved.
!
! Redistribution and use in source and binary forms, with or without modification, are 
! permitted provided that the following conditions are met:
!
!     - Redistributions of source code must retain the above copyright notice, this list 
!        of conditions and the following disclaimer.
!     - Redistributions in binary form must reproduce the above copyright notice, this 
!        list of conditions and the following disclaimer in the documentation and/or 
!        other materials provided with the distribution.
!     - Neither the names of Marc De Graef, Carnegie Mellon University nor the names 
!        of its contributors may be used to endorse or promote products derived from 
!        this software without specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
! ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
! LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
! DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
! SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
! CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
! OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
! USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
! ###################################################################

module mod_DREAM3D
  !! author: MDG 
  !! version: 1.0 
  !! date: 05/28/21
  !!
  !! module with DREAM3D support functions (mostly reading .dream3d files)

use mod_kinds
use mod_global
use iso_fortran_env, only: int64

IMPLICIT NONE 

type microstructure 
  real(kind=sgl),allocatable        :: EulerAngles(:,:,:,:) 
  integer(kind=irg),allocatable     :: FeatureIDs(:,:,:) 
  integer(kind=int64),allocatable   :: dimensions(:)
  real(kind=sgl),allocatable        :: origin(:)
  real(kind=sgl),allocatable        :: gridspacing(:)
  real(kind=sgl)                    :: samplescalefactor
end type microstructure 

contains

!--------------------------------------------------------------------------
subroutine ReadDREAM3Dfile(EMsoft, dname, microstr, EApath, FIDpath) 
!! author: MDG 
!! version: 1.0 
!! date: 05/28/21
!!
!! load a microstructure from an HDF5 file 
!! this assumes that the HDF5 interface has been initialized by the calling program 

use mod_EMsoft
use mod_IO 
use HDF5
use mod_HDFsupport 

IMPLICIT NONE 

type(EMsoft_T),INTENT(INOUT)          :: EMsoft 
character(fnlen),INTENT(IN)           :: dname 
type(microstructure),INTENT(INOUT)    :: microstr 
character(fnlen),INTENT(IN)           :: EApath(10) 
character(fnlen),INTENT(IN)           :: FIDpath(10) 

type(HDF_T)                           :: HDF 
type(IO_T)                            :: Message 

character(fnlen)                      :: fname, groupname, dataset  
logical                               :: f_exists, readonly 
integer(kind=irg)                     :: hdferr 
integer(HSIZE_T)                      :: dims(1), dims3(3), dims4(4)
integer(kind=int64),allocatable       :: dimensions(:)
real(kind=sgl),allocatable            :: origin(:)
real(kind=sgl),allocatable            :: gridspacing(:)
integer(kind=irg),allocatable         :: FeatureIDs(:,:,:,:) 

HDF = HDF_T()
fname = trim(EMsoft%generateFilePath('EMdatapathname',dname))

! make sure the file actually exists
inquire(file=trim(fname), exist=f_exists)
if (.not.f_exists) then
  call Message%printError('ReadDREAM3Dfile','DREAM3D file '//trim(fname)//' does not exist')
end if

! open the file in read-only mode
readonly = .TRUE.
hdferr =  HDF%openFile(fname, readonly)

! open the DataContainers group
groupname = 'DataContainers'
  hdferr = HDF%openGroup(groupname)

groupname = EApath(2)
  hdferr = HDF%openGroup(groupname)

!--------------------------------------------------------------------------
! in that group we have the _SIMPL_GEOMETRY group with the array dimensions 
groupname = '_SIMPL_GEOMETRY'
  hdferr = HDF%openGroup(groupname)

dataset = 'DIMENSIONS'
  call HDF%readDatasetInteger64Array(dataset, dims, hdferr, dimensions)
  allocate(microstr%dimensions(dims(1)))
  microstr%dimensions = dimensions

dataset = 'ORIGIN'
  call HDF%readDatasetFloatArray(dataset, dims, hdferr, origin)
  allocate(microstr%origin(dims(1)))
  microstr%origin = origin

dataset = 'SPACING'
  call HDF%readDatasetFloatArray(dataset, dims, hdferr, gridspacing)
  allocate(microstr%gridspacing(dims(1)))
  microstr%gridspacing = gridspacing

call HDF%pop()
!--------------------------------------------------------------------------

! next we get the EulerAngles and the FeatureIDs arrays from where ever they are located ... 
groupname = EApath(3)
  hdferr = HDF%openGroup(groupname)

dataset = trim(EApath(4))
  call HDF%readDatasetFloatArray(dataset, dims4, hdferr, microstr%EulerAngles)

dataset = trim(FIDpath(4))
  call HDF%readDatasetIntegerArray(dataset, dims4, hdferr, FeatureIDs)
  allocate(microstr%FeatureIDs(dims4(2),dims4(3),dims4(4)))
  microstr%FeatureIDs = FeatureIDs(1,:,:,:)
  deallocate(FeatureIDs, dimensions, origin, gridspacing)

! that's it, so we close the file 
call HDF%pop(.TRUE.)

call Message%printMessage(' Microstructure data read from DREAM.3D file '//trim(fname))

end subroutine ReadDREAM3Dfile


end module mod_DREAM3D