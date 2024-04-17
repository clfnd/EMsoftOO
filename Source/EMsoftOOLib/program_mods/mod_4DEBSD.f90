! ###################################################################
! Copyright (c) 2013-2024, Marc De Graef Research Group/Carnegie Mellon University
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

module mod_4DEBSD
  !! author: MDG 
  !! version: 1.0 
  !! date: 04/01/24
  !!
  !! class definition for the EM4DEBSD program

use mod_kinds
use mod_global

IMPLICIT NONE 

! namelist for the EMEBSD4D program
type, public :: EBSD4DNameListType
 integer(kind=irg)  :: ipf_ht
 integer(kind=irg)  :: ipf_wd
 integer(kind=irg)  :: ROI(4)
 integer(kind=irg)  :: numsx
 integer(kind=irg)  :: numsy
 integer(kind=irg)  :: nthreads
 integer(kind=irg)  :: VDwidth
 integer(kind=irg)  :: VDheight
 integer(kind=irg)  :: VDstep
 character(fnlen)   :: exptfile
 character(fnlen)   :: masterfile
 character(fnlen)   :: dotproductfile
 character(fnlen)   :: convolvedpatternfile
 character(fnlen)   :: inputtype
 character(fnlen)   :: HDFstrings(10)
 character(fnlen)   :: virtualimagefile
 character(5)       :: VDtype
 character(4)       :: VDreference
 logical            :: doconvolution
 real(kind=sgl)     :: EBSPlocx
 real(kind=sgl)     :: EBSPlocy
 real(kind=sgl)     :: VDlocx
 real(kind=sgl)     :: VDlocy
 real(kind=sgl)     :: VDSD
 real(kind=sgl)     :: VDHannAlpha
end type EBSD4DNameListType

! class definition
type, public :: EBSD4D_T
private 
  character(fnlen)          :: nmldeffile = 'EM4DEBSD.nml'
  type(EBSD4DNameListType)  :: nml 

contains
private 
  procedure, pass(self) :: readNameList_
  procedure, pass(self) :: getNameList_
  procedure, pass(self) :: writeHDFNameList_
  procedure, pass(self) :: EBSD4D_
  procedure, pass(self) :: EBSD4Dconvol_
  procedure, pass(self) :: setipf_ht_
  procedure, pass(self) :: getipf_ht_
  procedure, pass(self) :: setipf_wd_
  procedure, pass(self) :: getipf_wd_
  procedure, pass(self) :: setROI_
  procedure, pass(self) :: getROI_
  procedure, pass(self) :: setnumsx_
  procedure, pass(self) :: getnumsx_
  procedure, pass(self) :: setnumsy_
  procedure, pass(self) :: getnumsy_
  procedure, pass(self) :: setnthreads_
  procedure, pass(self) :: getnthreads_
  procedure, pass(self) :: setexptfile_
  procedure, pass(self) :: getexptfile_
  procedure, pass(self) :: setmasterfile_
  procedure, pass(self) :: getmasterfile_
  procedure, pass(self) :: setconvolvedpatternfile_
  procedure, pass(self) :: getconvolvedpatternfile_
  procedure, pass(self) :: setdotproductfile_
  procedure, pass(self) :: getdotproductfile_
  procedure, pass(self) :: setinputtype_
  procedure, pass(self) :: getinputtype_
  procedure, pass(self) :: setHDFstrings_
  procedure, pass(self) :: getHDFstrings_
  procedure, pass(self) :: setvirtualimagefile_
  procedure, pass(self) :: getvirtualimagefile_
  procedure, pass(self) :: setVDtype_
  procedure, pass(self) :: getVDtype_
  procedure, pass(self) :: setVDreference_
  procedure, pass(self) :: getVDreference_
  procedure, pass(self) :: setVDlocx_
  procedure, pass(self) :: getVDlocx_
  procedure, pass(self) :: setVDlocy_
  procedure, pass(self) :: getVDlocy_
  procedure, pass(self) :: setEBSPlocx_
  procedure, pass(self) :: getEBSPlocx_
  procedure, pass(self) :: setEBSPlocy_
  procedure, pass(self) :: getEBSPlocy_
  procedure, pass(self) :: setVDSD_
  procedure, pass(self) :: getVDSD_
  procedure, pass(self) :: setVDHannAlpha_
  procedure, pass(self) :: getVDHannAlpha_
  procedure, pass(self) :: setVDwidth_
  procedure, pass(self) :: getVDwidth_
  procedure, pass(self) :: setVDheight_
  procedure, pass(self) :: getVDheight_
  procedure, pass(self) :: setVDstep_
  procedure, pass(self) :: getVDstep_
  procedure, pass(self) :: setdoconvolution_
  procedure, pass(self) :: getdoconvolution_
  procedure, pass(self) :: drawMPpositions_
  procedure, pass(self) :: drawEBSPpositions_

  generic, public :: getNameList => getNameList_
  generic, public :: readNameList => readNameList_
  generic, public :: EBSD4D => EBSD4D_
  generic, public :: EBSD4Dconvol => EBSD4Dconvol_
  generic, public :: setipf_ht => setipf_ht_
  generic, public :: getipf_ht => getipf_ht_
  generic, public :: setipf_wd => setipf_wd_
  generic, public :: getipf_wd => getipf_wd_
  generic, public :: setROI => setROI_
  generic, public :: getROI => getROI_
  generic, public :: setnumsx => setnumsx_
  generic, public :: getnumsx => getnumsx_
  generic, public :: setnumsy => setnumsy_
  generic, public :: getnumsy => getnumsy_
  generic, public :: setnthreads => setnthreads_
  generic, public :: getnthreads => getnthreads_
  generic, public :: setexptfile => setexptfile_
  generic, public :: getexptfile => getexptfile_
  generic, public :: setdotproductfile => setdotproductfile_
  generic, public :: getdotproductfile => getdotproductfile_
  generic, public :: setmasterfile => setmasterfile_
  generic, public :: getmasterfile => getmasterfile_
  generic, public :: setconvolvedpatternfile => setconvolvedpatternfile_
  generic, public :: getconvolvedpatternfile => getconvolvedpatternfile_
  generic, public :: setinputtype => setinputtype_
  generic, public :: getinputtype => getinputtype_
  generic, public :: setHDFstrings => setHDFstrings_
  generic, public :: getHDFstrings => getHDFstrings_
  generic, public :: setvirtualimagefile => setvirtualimagefile_
  generic, public :: getvirtualimagefile => getvirtualimagefile_
  generic, public :: setVDtype => setVDtype_
  generic, public :: getVDtype => getVDtype_
  generic, public :: setVDreference => setVDreference_
  generic, public :: getVDreference => getVDreference_
  generic, public :: setVDlocx => setVDlocx_
  generic, public :: getVDlocx => getVDlocx_
  generic, public :: setVDlocy => setVDlocy_
  generic, public :: getVDlocy => getVDlocy_
  generic, public :: setEBSPlocx => setEBSPlocx_
  generic, public :: getEBSPlocx => getEBSPlocx_
  generic, public :: setEBSPlocy => setEBSPlocy_
  generic, public :: getEBSPlocy => getEBSPlocy_
  generic, public :: setVDSD => setVDSD_
  generic, public :: getVDSD => getVDSD_
  generic, public :: setVDHannAlpha => setVDHannAlpha_
  generic, public :: getVDHannAlpha => getVDHannAlpha_
  generic, public :: setVDwidth => setVDwidth_
  generic, public :: getVDwidth => getVDwidth_
  generic, public :: setVDheight => setVDheight_
  generic, public :: getVDheight => getVDheight_
  generic, public :: setVDstep => setVDstep_
  generic, public :: getVDstep => getVDstep_
  generic, public :: setdoconvolution => setdoconvolution_
  generic, public :: getdoconvolution => getdoconvolution_
end type EBSD4D_T

! the constructor routine for this class 
interface EBSD4D_T
  module procedure EBSD4D_constructor
end interface EBSD4D_T

contains

!--------------------------------------------------------------------------
type(EBSD4D_T) function EBSD4D_constructor( nmlfile ) result(EBSD4D)
!! author: MDG 
!! version: 1.0 
!! date: 04/01/24
!!
!! constructor for the EBSD4D_T Class; reads the name list 
 
IMPLICIT NONE

character(fnlen), OPTIONAL   :: nmlfile 

call EBSD4D%readNameList(nmlfile)

end function EBSD4D_constructor

!--------------------------------------------------------------------------
subroutine EBSD4D_destructor(self) 
!! author: MDG 
!! version: 1.0 
!! date: 04/01/24
!!
!! destructor for the EBSD4D_T Class
 
IMPLICIT NONE

type(EBSD4D_T), INTENT(INOUT)  :: self 

call reportDestructor('EBSD4D_T')

end subroutine EBSD4D_destructor

!--------------------------------------------------------------------------
subroutine readNameList_(self, nmlfile, initonly)
!DEC$ ATTRIBUTES DLLEXPORT :: readNameList_
!! author: MDG 
!! version: 1.0 
!! date: 04/01/24
!!
!! read the namelist from an nml file for the EBSD4D_T Class 

use mod_io 
use mod_EMsoft

IMPLICIT NONE 

class(EBSD4D_T), INTENT(INOUT)      :: self
character(fnlen),INTENT(IN)         :: nmlfile
 !! full path to namelist file 
logical,OPTIONAL,INTENT(IN)         :: initonly
 !! fill in the default values only; do not read the file

type(EMsoft_T)                      :: EMsoft 
type(IO_T)                          :: Message       
logical                             :: skipread = .FALSE.

integer(kind=irg)                   :: ipf_ht
integer(kind=irg)                   :: ipf_wd
integer(kind=irg)                   :: ROI(4)
integer(kind=irg)                   :: numsx
integer(kind=irg)                   :: numsy
integer(kind=irg)                   :: nthreads
character(fnlen)                    :: exptfile
character(fnlen)                    :: masterfile
character(fnlen)                    :: convolvedpatternfile
character(fnlen)                    :: dotproductfile
character(fnlen)                    :: inputtype
character(fnlen)                    :: HDFstrings(10)
character(fnlen)                    :: virtualimagefile
integer(kind=irg)                   :: VDwidth
integer(kind=irg)                   :: VDheight
integer(kind=irg)                   :: VDstep
character(5)                        :: VDtype
character(4)                        :: VDreference
logical                             :: doconvolution
real(kind=sgl)                      :: VDlocx
real(kind=sgl)                      :: VDlocy
real(kind=sgl)                      :: EBSPlocx
real(kind=sgl)                      :: EBSPlocy
real(kind=sgl)                      :: VDSD
real(kind=sgl)                      :: VDHannAlpha

namelist / EBSD4Ddata / ipf_ht, ipf_wd, ROI, numsx, numsy, nthreads, exptfile, inputtype, HDFstrings, virtualimagefile, &
                        VDwidth, VDheight, VDtype, VDlocx, VDlocy, VDSD, VDHannAlpha, VDreference, masterfile, dotproductfile, &
                        EBSPlocx, EBSPlocy, doconvolution, convolvedpatternfile, VDstep

ipf_ht = 100
ipf_wd = 100
ROI = (/ 0, 0, 0, 0 /)
numsx = 0
numsy = 0
nthreads = 1
exptfile = 'undefined'
masterfile = 'undefined'
convolvedpatternfile = 'undefined'
dotproductfile = 'undefined'
inputtype = 'Binary'
HDFstrings = (/ '', '', '', '', '', '', '', '', '', '' /)
virtualimagefile = 'undefined'
VDtype = 'Rect'
VDreference = 'EBSP'
VDlocx = 0.0 
VDlocy = 0.0
EBSPlocx = 0.0 
EBSPlocy = 0.0
VDwidth = 5
VDheight = 5
VDstep = 8
VDSD = 0.5
VDHannAlpha = 0.5 
doconvolution = .FALSE.

if (present(initonly)) then
  if (initonly) skipread = .TRUE.
end if

if (.not.skipread) then
! read the namelist file
 open(UNIT=dataunit,FILE=trim(nmlfile),DELIM='apostrophe',STATUS='old')
 read(UNIT=dataunit,NML=EBSD4Ddata)
 close(UNIT=dataunit,STATUS='keep')

! check for required entries
 if (trim(exptfile).eq.'undefined') then
  call Message%printError('readNameList:',' exptfile file name is undefined in '//nmlfile)
 end if

 if (trim(virtualimagefile).eq.'undefined') then
  call Message%printError('readNameList:',' virtualimagefile file name is undefined in '//nmlfile)
 end if

 if (numsx.eq.0) then
  call Message%printError('readNameList:',' pattern size numsx is zero '//nmlfile)
 end if

 if (numsy.eq.0) then
  call Message%printError('readNameList:',' pattern size numsy is zero '//nmlfile)
 end if

 if (VDreference.eq.'MPat') then 
   if (trim(masterfile).eq.'undefined') then
    call Message%printError('readNameList:',' masterfile file name is undefined in '//nmlfile)
   end if
   if (trim(dotproductfile).eq.'undefined') then
    call Message%printError('readNameList:',' dotproductfile file name is undefined in '//nmlfile)
   end if
 end if

 if (trim(VDtype).eq.'Array') then 
   if (trim(convolvedpatternfile).eq.'undefined') then 
    call Message%printError('readNameList:',' convolvedpatternfile file name is undefined in '//nmlfile)
   end if 
 end if 
end if

self%nml%ipf_ht = ipf_ht
self%nml%ipf_wd = ipf_wd
self%nml%ROI = ROI
self%nml%numsx = numsx
self%nml%numsy = numsy
self%nml%nthreads = nthreads
self%nml%exptfile = exptfile
self%nml%masterfile = masterfile
self%nml%convolvedpatternfile = convolvedpatternfile
self%nml%dotproductfile = dotproductfile
self%nml%inputtype = inputtype
self%nml%HDFstrings = HDFstrings
self%nml%virtualimagefile = virtualimagefile
self%nml%VDwidth = VDwidth
self%nml%VDheight = VDheight
self%nml%VDstep = VDstep
self%nml%VDtype = trim(VDtype)
self%nml%VDreference = VDreference
self%nml%VDlocx = VDlocx
self%nml%VDlocy = VDlocy
self%nml%EBSPlocx = EBSPlocx
self%nml%EBSPlocy = EBSPlocy
self%nml%VDSD = VDSD 
self%nml%VDHannAlpha = VDHannAlpha
self%nml%doconvolution = doconvolution

end subroutine readNameList_

!--------------------------------------------------------------------------
recursive subroutine writeHDFNameList_(self, HDF, HDFnames)
!DEC$ ATTRIBUTES DLLEXPORT :: writeHDFNameList_
!! author: MDG
!! version: 1.0
!! date: 02/17/20
!!
!! write namelist to HDF file

use mod_HDFsupport
use mod_HDFnames
use stringconstants

use ISO_C_BINDING

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)          :: self
type(HDF_T), INTENT(INOUT)              :: HDF
type(HDFnames_T), INTENT(INOUT)         :: HDFnames

integer(kind=irg),parameter             :: n_int = 9, n_real = 6
integer(kind=irg)                       :: hdferr,  io_int(n_int), docv
real(kind=sgl)                          :: io_real(n_real)
character(20)                           :: reallist(n_real)
character(20)                           :: intlist(n_int)
character(fnlen)                        :: dataset, sval(1),groupname
character(fnlen,kind=c_char)            :: line2(1), line10(10)

associate( enl => self%nml )

! create the group for this namelist
hdferr = HDF%createGroup(HDFnames%get_NMLlist())

docv = 0 
if (enl%doconvolution.eqv..TRUE.) docv = 1
! write all the single integers
io_int = (/ enl%ipf_wd, enl%ipf_ht, enl%numsx, enl%numsy, enl%nthreads, enl%VDwidth, enl%VDheight, enl%VDstep, docv/)
intlist(1) = 'ipf_wd'
intlist(2) = 'ipf_ht'
intlist(3) = 'numsx'
intlist(4) = 'numsy'
intlist(5) = 'nthreads'
intlist(6) = 'VDwidth'
intlist(7) = 'VDheight'
intlist(8) = 'VDstep'
intlist(9) = 'doconvolution'
call HDF%writeNMLintegers(io_int, intlist, n_int)

! write all the single reals
io_real = (/ enl%VDlocx, enl%VDlocy, enl%EBSPlocx, enl%EBSPlocy, enl%VDSD, enl%VDHannAlpha /)
reallist(1) = 'VDlocx'
reallist(2) = 'VDlocy'
reallist(3) = 'EBSPlocx'
reallist(4) = 'EBSPlocy'
reallist(5) = 'VDSD'
reallist(6) = 'VDHannAlpha'
call HDF%writeNMLreals(io_real, reallist, n_real)

! a 4-vector
dataset = SC_ROI
hdferr = HDF%writeDatasetIntegerArray(dataset, enl%ROI, 4)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create ROI dataset', hdferr)

! write all the strings
dataset = SC_exptfile
line2(1) = trim(enl%exptfile)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create exptfile dataset', hdferr)

dataset = SC_masterfile
line2(1) = trim(enl%masterfile)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create masterfile dataset', hdferr)

dataset = 'convolvedpatternfile' 
line2(1) = trim(enl%convolvedpatternfile)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create poissconvolvedpatternfileon dataset', hdferr)

dataset = 'dotproductfile'
line2(1) = trim(enl%dotproductfile)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create dotproductfile dataset', hdferr)

dataset = SC_inputtype
line2(1) = trim(enl%inputtype)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create inputtype dataset', hdferr)

dataset = 'virtualimagefile'
line2(1) = trim(enl%virtualimagefile)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create virtualimagefile dataset', hdferr)

dataset = 'VDtype'
line2(1) = trim(enl%VDtype)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create VDtype dataset', hdferr)

dataset = 'VDreference' 
line2(1) = trim(enl%VDreference)
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create VDreference dataset', hdferr)

dataset = SC_HDFstrings
line10 = enl%HDFstrings
hdferr = HDF%writeDatasetStringArray(dataset, line10, 10)
if (hdferr.ne.0) call HDF%error_check('writeHDFNameList: unable to create HDFstrings dataset', hdferr)

! and pop this group off the stack
call HDF%pop()

end associate

end subroutine writeHDFNameList_

!--------------------------------------------------------------------------
function getNameList_(self) result(nml)
!DEC$ ATTRIBUTES DLLEXPORT :: getNameList_
!! author: MDG 
!! version: 1.0 
!! date: 04/01/24
!!
!! pass the namelist for the EBSD4D_T Class to the calling program

IMPLICIT NONE 

class(EBSD4D_T), INTENT(INOUT)   :: self
type(EBSD4DNameListType)         :: nml

nml = self%nml

end function getNameList_

!--------------------------------------------------------------------------
subroutine setipf_ht_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setipf_ht_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set ipf_ht in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%ipf_ht = inp

end subroutine setipf_ht_

!--------------------------------------------------------------------------
function getipf_ht_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getipf_ht_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get ipf_ht from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%ipf_ht

end function getipf_ht_

!--------------------------------------------------------------------------
subroutine setipf_wd_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setipf_wd_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set ipf_wd in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%ipf_wd = inp

end subroutine setipf_wd_

!--------------------------------------------------------------------------
function getipf_wd_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getipf_wd_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get ipf_wd from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%ipf_wd

end function getipf_wd_

!--------------------------------------------------------------------------
subroutine setROI_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setROI_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set ROI in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)      :: inp(4)

self%nml%ROI = inp

end subroutine setROI_

!--------------------------------------------------------------------------
function getROI_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getROI_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get ROI from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                  :: out(4)

out = self%nml%ROI

end function getROI_

!--------------------------------------------------------------------------
subroutine setnumsx_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setnumsx_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set numsx in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%numsx = inp

end subroutine setnumsx_

!--------------------------------------------------------------------------
function getnumsx_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getnumsx_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get numsx from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%numsx

end function getnumsx_

!--------------------------------------------------------------------------
subroutine setnumsy_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setnumsy_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set numsy in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%numsy = inp

end subroutine setnumsy_

!--------------------------------------------------------------------------
function getnumsy_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getnumsy_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get numsy from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%numsy

end function getnumsy_

!--------------------------------------------------------------------------
subroutine setnthreads_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setnthreads_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set nthreads in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%nthreads = inp

end subroutine setnthreads_

!--------------------------------------------------------------------------
function getnthreads_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getnthreads_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get nthreads from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%nthreads

end function getnthreads_

!--------------------------------------------------------------------------
subroutine setexptfile_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setexptfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set exptfile in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp

self%nml%exptfile = trim(inp)

end subroutine setexptfile_

!--------------------------------------------------------------------------
function getexptfile_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getexptfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get exptfile from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out

out = trim(self%nml%exptfile)

end function getexptfile_

!--------------------------------------------------------------------------
subroutine setmasterfile_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setmasterfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set masterfile in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp

self%nml%masterfile = trim(inp)

end subroutine setmasterfile_

!--------------------------------------------------------------------------
function getmasterfile_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getmasterfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get masterfile from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out

out = trim(self%nml%masterfile)

end function getmasterfile_

!--------------------------------------------------------------------------
subroutine setconvolvedpatternfile_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setconvolvedpatternfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set convolvedpatternfile in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp

self%nml%convolvedpatternfile = trim(inp)

end subroutine setconvolvedpatternfile_

!--------------------------------------------------------------------------
function getconvolvedpatternfile_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getconvolvedpatternfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get convolvedpatternfile from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out

out = trim(self%nml%convolvedpatternfile)

end function getconvolvedpatternfile_

!--------------------------------------------------------------------------
subroutine setdotproductfile_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setdotproductfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set dotproductfile in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp

self%nml%dotproductfile = trim(inp)

end subroutine setdotproductfile_

!--------------------------------------------------------------------------
function getdotproductfile_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getdotproductfile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get dotproductfile from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out

out = trim(self%nml%dotproductfile)

end function getdotproductfile_

!--------------------------------------------------------------------------
subroutine setinputtype_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setinputtype_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set inputtype in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp

self%nml%inputtype = trim(inp)

end subroutine setinputtype_

!--------------------------------------------------------------------------
function getinputtype_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getinputtype_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get inputtype from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out

out = trim(self%nml%inputtype)

end function getinputtype_

!--------------------------------------------------------------------------
subroutine setHDFstrings_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setHDFstrings_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set HDFstrings in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp(10)

integer(kind=irg)                  :: i 

do i=1,10 
  self%nml%HDFstrings(i) = trim(inp(i))
end do 

end subroutine setHDFstrings_

!--------------------------------------------------------------------------
function getHDFstrings_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getHDFstrings_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get HDFstrings from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out(10)

integer(kind=irg)                  :: i 

do i=1,10 
  out(i) = trim(self%nml%HDFstrings(i))
end do 

end function getHDFstrings_

!--------------------------------------------------------------------------
subroutine setvirtualimagefile_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setvirtualimagefile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set virtualimagefile in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen), INTENT(IN)       :: inp

self%nml%virtualimagefile = trim(inp)

end subroutine setvirtualimagefile_

!--------------------------------------------------------------------------
function getvirtualimagefile_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getvirtualimagefile_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get virtualimagefile from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(fnlen)                   :: out

out = trim(self%nml%virtualimagefile)

end function getvirtualimagefile_

!--------------------------------------------------------------------------
subroutine setVDtype_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDtype_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDtype in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(4), INTENT(IN)       :: inp

self%nml%VDtype = trim(inp)

end subroutine setVDtype_

!--------------------------------------------------------------------------
function getVDtype_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDtype_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDtype from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(4)                   :: out

out = trim(self%nml%VDtype)

end function getVDtype_

!--------------------------------------------------------------------------
subroutine setVDreference_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDreference_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDreference in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(4), INTENT(IN)       :: inp

self%nml%VDreference = trim(inp)

end subroutine setVDreference_

!--------------------------------------------------------------------------
function getVDreference_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDreference_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDreference from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
character(4)                   :: out

out = trim(self%nml%VDreference)

end function getVDreference_

!--------------------------------------------------------------------------
subroutine setVDlocx_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDlocx_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDlocx in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl), INTENT(IN)       :: inp

self%nml%VDlocx = inp

end subroutine setVDlocx_

!--------------------------------------------------------------------------
function getVDlocx_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDlocx_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDlocx from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl)                   :: out

out = self%nml%VDlocx

end function getVDlocx_

!--------------------------------------------------------------------------
subroutine setVDlocy_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDlocy_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDlocy in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl), INTENT(IN)       :: inp

self%nml%VDlocy = inp

end subroutine setVDlocy_

!--------------------------------------------------------------------------
function getVDlocy_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDlocy_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDlocy from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl)                   :: out

out = self%nml%VDlocy

end function getVDlocy_

!--------------------------------------------------------------------------
subroutine setEBSPlocx_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setEBSPlocx_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set EBSPlocx in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl), INTENT(IN)       :: inp

self%nml%EBSPlocx = inp

end subroutine setEBSPlocx_

!--------------------------------------------------------------------------
function getEBSPlocx_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getEBSPlocx_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get EBSPlocx from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl)                   :: out

out = self%nml%EBSPlocx

end function getEBSPlocx_

!--------------------------------------------------------------------------
subroutine setEBSPlocy_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setEBSPlocy_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set EBSPlocy in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl), INTENT(IN)       :: inp

self%nml%EBSPlocy = inp

end subroutine setEBSPlocy_

!--------------------------------------------------------------------------
function getEBSPlocy_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getEBSPlocy_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get EBSPlocy from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl)                   :: out

out = self%nml%EBSPlocy

end function getEBSPlocy_

!--------------------------------------------------------------------------
subroutine setVDSD_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDSD_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDSD in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl), INTENT(IN)       :: inp

self%nml%VDSD = inp

end subroutine setVDSD_

!--------------------------------------------------------------------------
function getVDSD_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDSD_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDSD from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl)                   :: out

out = self%nml%VDSD

end function getVDSD_

!--------------------------------------------------------------------------
subroutine setVDHannAlpha_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDHannAlpha_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDHannAlpha in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl), INTENT(IN)       :: inp

self%nml%VDHannAlpha = inp

end subroutine setVDHannAlpha_

!--------------------------------------------------------------------------
function getVDHannAlpha_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDHannAlpha_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDHannAlpha from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
real(kind=sgl)                   :: out

out = self%nml%VDHannAlpha

end function getVDHannAlpha_

!--------------------------------------------------------------------------
subroutine setVDwidth_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDwidth_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDwidth in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%VDwidth = inp

end subroutine setVDwidth_

!--------------------------------------------------------------------------
function getVDwidth_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDwidth_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDwidth from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%VDwidth

end function getVDwidth_

!--------------------------------------------------------------------------
subroutine setVDheight_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDheight_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDheight in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%VDheight = inp

end subroutine setVDheight_

!--------------------------------------------------------------------------
function getVDheight_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDheight_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDheight from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%VDheight

end function getVDheight_

!--------------------------------------------------------------------------
subroutine setVDstep_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setVDstep_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! set VDstep in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg), INTENT(IN)       :: inp

self%nml%VDstep = inp

end subroutine setVDstep_

!--------------------------------------------------------------------------
function getVDstep_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getVDstep_
!! author: MDG
!! version: 1.0
!! date: 04/01/24
!!
!! get VDstep from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
integer(kind=irg)                   :: out

out = self%nml%VDstep

end function getVDstep_

!--------------------------------------------------------------------------
subroutine setdoconvolution_(self,inp)
!DEC$ ATTRIBUTES DLLEXPORT :: setdoconvolution_
!! author: MDG
!! version: 1.0
!! date: 04/15/24
!!
!! set doconvolution in the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
logical, INTENT(IN)                :: inp

self%nml%doconvolution = inp

end subroutine setdoconvolution_

!--------------------------------------------------------------------------
function getdoconvolution_(self) result(out)
!DEC$ ATTRIBUTES DLLEXPORT :: getdoconvolution_
!! author: MDG
!! version: 1.0
!! date: 04/15/24
!!
!! get doconvolution from the EBSD4D_T class

IMPLICIT NONE

class(EBSD4D_T), INTENT(INOUT)     :: self
logical                            :: out

out = self%nml%doconvolution

end function getdoconvolution_

!--------------------------------------------------------------------------
subroutine drawMPpositions_(self, n, ctmp, sz, MP)
!DEC$ ATTRIBUTES DLLEXPORT :: drawMPpositions_
!! author: MDG 
!! version: 1.0 
!! date: 04/05/24
!!
!! superimpose equivalent positions onto a master pattern 

use mod_image
use mod_io 

use, intrinsic :: iso_fortran_env

class(EBSD4D_T),INTENT(INOUT)     :: self
integer(kind=irg),INTENT(IN)      :: n 
real(kind=dbl),INTENT(IN)         :: ctmp(n,3)
integer(kind=irg),INTENT(IN)      :: sz(3)
real(kind=sgl),INTENT(IN)         :: MP(sz(1),sz(2),sz(3))

type(IO_T)                        :: Message 

real(kind=sgl)                    :: SP(sz(1),sz(2)), ma, mi
integer(kind=irg)                 :: i, j, npx, w, x, y
character(fnlen)                  :: TIFF_filename

! declare variables for use in object oriented image module
integer                           :: iostat
character(len=128)                :: iomsg
logical                           :: isInteger
type(image_t)                     :: im
integer(int8)                     :: i8 (3,4)
integer(int8), allocatable        :: TIFF_image(:,:)

TIFF_filename = 'Debug_MPpositions.tiff'
allocate(TIFF_image(sz(1),sz(2)))
npx = (sz(1)-1)/2 
w = 2

! pick one of the energy levels
SP = MP(:,:,sz(3)-1)
ma = maxval(SP)

! loop over all equivalent points in the Northern hemisphere 
do i=1,n 
  if (ctmp(i,3).gt.0.0) then 
! stereographic coordinates
    x = nint( npx * ctmp(i,1)/(1.0+ctmp(i,3)) ) + npx
    y = nint( npx * ctmp(i,2)/(1.0+ctmp(i,3)) ) + npx
    ! write (*,*) ctmp(i,1), ctmp(i,2), x, y 
! make a little bright square at this location 
    SP( x-w:x+w, y-w:y+w ) = ma
  end if 
end do 

! and generate the tiff output file 
ma = maxval(SP)
mi = minval(SP)

TIFF_image = int( 255 * (SP-mi)/(ma-mi) )

! set up the image_t structure
im = image_t(TIFF_image)
if(im%empty()) call Message%printMessage("drawMPpositions_","failed to convert array to image")

! create the file
call im%write(trim(TIFF_filename), iostat, iomsg) ! format automatically detected from extension
if(0.ne.iostat) then
  call Message%printMessage("failed to write image to file : "//iomsg)
else
  call Message%printMessage(' MPpositions map written to '//trim(TIFF_filename))
end if

end subroutine drawMPpositions_

!--------------------------------------------------------------------------
subroutine drawEBSPpositions_(self, sz, pat)
!DEC$ ATTRIBUTES DLLEXPORT :: drawEBSPpositions_
!! author: MDG 
!! version: 1.0 
!! date: 04/05/24
!!
!! save an EBSP pattern with a virtual detector superimposed for debugging purposes

use mod_image
use mod_io 

use, intrinsic :: iso_fortran_env

class(EBSD4D_T),INTENT(INOUT)     :: self
integer(kind=irg),INTENT(IN)      :: sz(2)
real(kind=sgl),INTENT(IN)         :: pat(sz(1),sz(2))

type(IO_T)                        :: Message 

real(kind=sgl)                    :: ma, mi
character(fnlen)                  :: TIFF_filename

! declare variables for use in object oriented image module
integer                           :: iostat
character(len=128)                :: iomsg
logical                           :: isInteger
type(image_t)                     :: im
integer(int8)                     :: i8 (3,4)
integer(int8), allocatable        :: TIFF_image(:,:)

TIFF_filename = 'Debug_EBSPpositions.tiff'
allocate(TIFF_image(sz(1),sz(2)))

! and generate the tiff output file 
ma = maxval(pat)
mi = minval(pat)

TIFF_image = int( 255 * (pat-mi)/(ma-mi) )

! set up the image_t structure
im = image_t(TIFF_image)
if(im%empty()) call Message%printMessage("drawEBSPpositions_","failed to convert array to image")

! create the file
call im%write(trim(TIFF_filename), iostat, iomsg) ! format automatically detected from extension
if(0.ne.iostat) then
  call Message%printMessage("failed to write image to file : "//iomsg)
else
  call Message%printMessage(' EBSPpositions map written to '//trim(TIFF_filename))
end if

end subroutine drawEBSPpositions_

!--------------------------------------------------------------------------
subroutine EBSD4D_(self, EMsoft, progname, HDFnames)
!DEC$ ATTRIBUTES DLLEXPORT :: EBSD4D_
!! author: MDG 
!! version: 1.0 
!! date: 04/01/24
!!
!! perform the computations

use mod_EMsoft
use mod_HDFnames
use mod_patterns
use mod_vendors
use mod_filters
use mod_MCfiles
use mod_MPfiles
use mod_DIfiles
use mod_quaternions
use mod_rotations
use mod_crystallography
use mod_symmetry
use mod_PGA3D
use mod_PGA3Dsupport
use mod_io
use mod_math
use mod_timing
use omp_lib
use mod_OMPsupport
use HDF5
use h5im
use h5lt
use mod_HDFsupport
use ISO_C_BINDING
use mod_DIfiles
use mod_image
use mod_NLPAR
use mod_memory

use, intrinsic :: iso_fortran_env

IMPLICIT NONE 

class(EBSD4D_T), INTENT(INOUT)          :: self
type(EMsoft_T), INTENT(INOUT)           :: EMsoft
character(fnlen), INTENT(INOUT)         :: progname 
type(HDFnames_T), INTENT(INOUT)         :: HDFnames

type(IO_T)                              :: Message
type(HDF_T)                             :: HDF
type(timing_T)                          :: timer
type(NLPAR_T)                           :: NLPAR 
type(memory_T)                          :: mem
type(Vendor_T)                          :: VT
type(DIfile_T)                          :: DIFT
type(MPfile_T)                          :: MPFT
type(MCfile_T)                          :: MCFT
type(QuaternionArray_T)                 :: qAR
type(Quaternion_T)                      :: quat
type(e_T)                               :: eu
type(q_T)                               :: qu 
type(HDFnames_T)                        :: saveHDFnames
type(EBSDmasterNameListType)            :: mpnl
type(MCOpenCLNameListType)              :: mcnl
type(Cell_T)                            :: cell 
type(SpaceGroup_T)                      :: SG
type(PGA3D_T)                           :: mv_plane, mv_line, mv

integer(kind=irg)                       :: L,totnumexpt,imght,imgwd, recordsize, hdferr, TID, iii, VDposx, VDposy, VDpx, VDpy,&
                                           TIFF_nx, TIFF_ny, itype, istat, iiistart, iiiend, jjstart, jjend, binx, biny, sz(3), &
                                           correctsize, dims(2), i, j, ii, jj, jjj, kk, patsz, Nexp, numhatn, io_int(4), sz2(2), &
                                           VDpxref, VDpyref, VDkk, ival, kkk, lll, numpatx, numpaty
integer(kind=ill)                       :: jjpat
logical                                 :: ROIselected
real(kind=sgl),allocatable              :: VDimage(:,:), exppatarray(:), VDmask(:,:), mask(:,:), Pat(:,:), window(:,:), &
                                           euler(:,:), expt(:), EBSP(:,:), montage(:,:)
real(kind=dbl),allocatable              :: VDmaskd(:,:), VDpositions(:,:), newctmp(:,:)
integer(kind=irg),allocatable           :: VDpos(:)
real(kind=sgl)                          :: mi, ma
real(kind=dbl)                          :: Xs, Ys, theta, phi, hatn(3), px, py, pos(3), xbound, ybound, dl
real(kind=dbl)                          :: LL, a, b, c, d, alpha, x, y, z, sa, ca, dis
integer(HSIZE_T)                        :: dims3(3), offset3(3)
character(fnlen)                        :: fname, TIFF_filename, DIfile, HDFstrings(10) 
real(kind=dbl),allocatable              :: ctmp(:,:)
real(kind=dbl),allocatable              :: rrdata(:,:), ffdata(:,:), ksqarray(:,:)
complex(kind=dbl),allocatable           :: hpmask(:,:)
complex(C_DOUBLE_COMPLEX),allocatable   :: inp(:,:), outp(:,:)
type(C_PTR)                             :: planf, HPplanf, HPplanb

! declare variables for use in object oriented image module
integer                                 :: iostat
character(len=128)                      :: iomsg
logical                                 :: isInteger
type(image_t)                           :: im
integer(int8)                           :: i8 (3,4)
integer(int8), allocatable              :: TIFF_image(:,:)

call openFortranHDFInterface()
HDF = HDF_T()

call setRotationPrecision('d')

associate( nml=>self%nml, DIDT=>DIFT%DIDT )

! memory class 
mem = memory_T()

! copy various constants from the namelist
L = nml%numsx*nml%numsy
totnumexpt = nml%ipf_wd*nml%ipf_ht
imght = nml%numsx
imgwd = nml%numsy
recordsize = L*4
dims = (/ imght, imgwd /)
binx = nml%numsx
biny = nml%numsy

! make sure that correctsize is a multiple of 16; if not, make it so
! this is not really relevant for this program, but several routines 
! rely on this being the case so we impose it here
if (mod(L,16) .ne. 0) then
    correctsize = 16*ceiling(float(L)/16.0)
else
    correctsize = L
end if
patsz = correctsize

ROIselected = .FALSE.
if (sum(nml%ROI).ne.0) ROIselected = .TRUE.

if (nml%VDreference.eq.'MPat') then 

!===================================================================================
! read info from the dot product file
  DIfile = trim(EMsoft%generateFilePath('EMdatapathname'))//trim(nml%dotproductfile)
  saveHDFnames = HDFnames
  call HDFnames%set_NMLfiles(SC_NMLfiles)
  call HDFnames%set_NMLfilename(SC_DictionaryIndexingNML)
  call HDFnames%set_NMLparameters(SC_NMLparameters)
  call HDFnames%set_NMLlist(SC_DictionaryIndexingNameListType)
  call DIFT%readDotProductFile(EMsoft, HDF, HDFnames, DIfile, hdferr, &
                               getRefinedEulerAngles=.TRUE.)

  Nexp = DIDT%Nexp
  call mem%alloc(euler, (/ 3, Nexp /), 'euler')
  euler(1:3,1:Nexp) = DIDT%RefinedEulerAngles(1:3,1:Nexp)
  deallocate(DIDT%RefinedEulerAngles)

  qAR = QuaternionArray_T( n = Nexp, s = 'd' )
  do ii = 1,Nexp
    eu = e_T( edinp = dble(euler(1:3,ii)) )
    qu = eu%eq()
    quat = Quaternion_T( qd = qu%q_copyd() )
    call quat%quat_pos()
    call qAR%insertQuatinArray(ii, quat)
  end do
  call mem%dealloc(euler, 'euler')
  call Message%printMessage(' --> Completed reading orientation data from '//trim(DIfile))

!===================================================================================
! read namelist info from the master pattern file
  call HDFnames%set_ProgramData(SC_MCOpenCL)
  call HDFnames%set_NMLlist(SC_MCCLNameList)
  call HDFnames%set_NMLfilename(SC_MCOpenCLNML)
  fname = EMsoft%generateFilePath('EMdatapathname',trim(nml%masterfile))
  call MCFT%setFileName(fname)
  call MCFT%readMCfile(HDF, HDFnames)
  mcnl = MCFT%getnml()

  call HDFnames%set_ProgramData(SC_EBSDmaster)
  call HDFnames%set_NMLlist(SC_EBSDmasterNameList)
  call HDFnames%set_NMLfilename(SC_EBSDmasterNML)
  fname = EMsoft%generateFilePath('EMdatapathname',trim(nml%masterfile))
  call MPFT%setFileName(fname)
  call MPFT%setModality('EBSD')
  call MPFT%readMPfile(HDF, HDFnames, mpnl, getmasterSPNH=.TRUE.)
  HDFnames = saveHDFnames

!===================================================================================
! and finally read and initialize the crystallographic information 
  call cell%getCrystalData(mcnl%xtalname, SG, EMsoft)
  call Message%printMessage(' --> Completed reading crystal structure data from '//trim(mcnl%xtalname))
end if

!===================================================================================
! set the vendor inputtype and file name for the pattern file
if (nml%VDtype.eq.'Array') then 
! here we need to use the pre-computed convolvedpatternfile (HDF5) and read the patterns from it
! so, we redefine the inputtype to be the TSLHDF type and set the HDFstrings variable to the 
! appropriate strings
  itype = 11
  VT = Vendor_T()
  call VT%set_itype( itype )
  call VT%set_inputtype( 'EMEBSD32f')
  call VT%set_filename( nml%convolvedpatternfile )
  HDFstrings = ''
  HDFstrings(1) = 'EMData'
  HDFstrings(2) = 'EBSD4D'
  HDFstrings(3) = 'ConvolvedPatterns'
  call self%setHDFstrings_( HDFstrings )
else
  VT = Vendor_T( nml%inputtype )
  itype = VT%get_itype()
  call VT%set_filename( nml%exptfile )
end if

!===================================================================================
! open the file with experimental patterns; depending on the inputtype parameter, this
! can be a regular binary file, as produced by a MatLab or IDL script (default); a
! pattern file produced by EMEBSD.f90 etc.; or a vendor binary or HDF5 file... in each case we need to
! open the file and leave it open, then use the getExpPatternRow() routine to read a row
! of patterns into the exppatarray variable ...  at the end, we use closeExpPatternFile() to
! properly close the experimental pattern file
if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) .or. (itype.eq.11) ) then
  HDF = HDF_T()
  istat = VT%openExpPatternFile(EMsoft, nml%ipf_wd, L, recordsize, nml%HDFstrings, HDF)
else
  istat = VT%openExpPatternFile(EMsoft, nml%ipf_wd, L, recordsize)
end if

if (istat.ne.0) then
    call Message%printError("EBSD4D:", "Fatal error handling experimental pattern file")
end if

if (sum(nml%ROI).ne.0) then
  ROIselected = .TRUE.
  iiistart = nml%ROI(2)
  iiiend = nml%ROI(2)+nml%ROI(4)-1
  jjstart = nml%ROI(1)
  jjend = nml%ROI(1)+nml%ROI(3)-1
else
  ROIselected = .FALSE.
  iiistart = 1
  iiiend = nml%ipf_ht
  jjstart = 1
  jjend = nml%ipf_wd
end if

! allocate the output image array
if (ROIselected.eqv..TRUE.) then
  call mem%alloc(VDimage, (/ nml%ROI(3), nml%ROI(4) /), 'VDimage')
else
  call mem%alloc(VDimage, (/ nml%ipf_wd, nml%ipf_ht /), 'VDimage')
end if
call mem%alloc(VDmask, (/ nml%VDwidth, nml%VDheight /), 'VDmask')
call mem%alloc(VDmaskd, (/ nml%VDwidth, nml%VDheight /), 'VDmaskd')
call mem%alloc(exppatarray, (/ patsz * nml%ipf_wd /), 'exppatarray')
call mem%alloc(mask, (/ nml%VDwidth, nml%VDheight /), 'mask', initval=0.0)

! make the mask according to the virtual detector type 
select case(nml%VDtype)
  case('Rect')
    VDmask = 1.0
  case('Hann')
    call HannWindow(nml%VDwidth, VDmaskd, dble(nml%VDHannAlpha))
    VDmask = sngl(VDmaskd)
    call mem%dealloc(VDmaskd, 'VDmaskd')
  case('Array')
    VDmask = 1.0

  case default 
    call Message%printError('EBSD4D','virtual detector type not yet implemented')
end select

if (nml%VDreference.eq.'MPat') then 
! convert the coordinates into a unit direction vector, then determine all
! the equivalent orientations, project them all onto the EBSD detector and
! pick the one that is closest to the pattern center... this will need to 
! be done for each pixel separately so we can simply compute all of them 
! ahead of time and store them
! 
! get the normalized coordinates from the stereographic projection of the master pattern
  Xs = nml%VDlocx/dble(mpnl%npx)
  Ys = nml%VDlocy/dble(mpnl%npx)
! convert them into the spherical angles 
  theta = acos( (1.D0-Xs**2-Ys**2) / (1.D0+Xs**2+Ys**2) )
  phi = atan2(Ys, Xs)
! then get the unit vector on the Kikuchi sphere that represents the location of the virtual detector center
  hatn = (/ sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta) /)
! next, we want to get all symmetrically equivalent virtual detector positions on the Kikuchi sphere
  call SG%CalcStar( hatn, numhatn, ctmp, 'd' )
  io_int(1) = numhatn
  call Message%WriteValue(' Number of equivalent virtual detectors on Kikuchi sphere : ', io_int, 1)
! draw the equivalent point on the master pattern to make sure this step is correct
  sz = shape(MPFT%MPDT%masterSPNH)
  call self%drawMPpositions_(numhatn, ctmp, sz, MPFT%MPDT%masterSPNH)
! convert each of these to detector coordinates for each orientation/sampling pixel
! and keep the one that is closest to the center of the detector (3-rd component is distance)
  call mem%alloc( VDpositions, (/ 3, Nexp /), 'VDpositions' )
!*********
! we use projective geometric algebra to find the intersection point on the detector
  call Message%printMessage(' --> initializing Projective Geometric Algebra')
  call PGA3D_initialize()
!*********
! define the detector mv_plane (mv = 16-component multivector)
  LL = DIFT%nml%L
  alpha = cPi*0.5D0 - mcnl%sig*dtor + DIFT%nml%thetac * dtor
  sa = sin(alpha)
  ca = cos(alpha)
  a = LL * sa
  b = 0.D0 
  c = LL * ca
  d = LL*LL
  mv_plane = plane(a,b,c,d)
  call mv_plane%log(' Detector plane ')
  dl = DIFT%nml%delta
! for each sampling point, transform all numhatn vectors to the sample frame using the 
! corresponding orientation quaternion from the qAR list; then determine where those 
! unit vectors would intersect the detector plane using meet(mv_plane, mv_line) and 
! check to make sure that the resulting point lies inside the detector; update this point 
! in the list until we have found the one closest to location corresponding to the pattern
! at (EBSPlocx, EBSPlocy)
!
! load this pattern from the pattern file and put the detector(s) on it as a debug step 
  call mem%alloc(newctmp, (/ 3, numhatn /), 'newctmp')
  xbound = dl * DIFT%nml%exptnumsx/2
  ybound = dl * DIFT%nml%exptnumsy/2
  jj = (nint(nml%EBSPlocy)-1) * nml%ipf_wd + nint(nml%EBSPlocx) 
  allocate(expt(patsz), EBSP(binx, biny))
  dims3 = (/ binx, biny, 1 /)
  offset3 = (/ 0, 0, jj /)
  call VT%getSingleExpPattern(nint(nml%EBSPlocy), nml%ipf_wd, patsz, L, dims3, offset3, expt, nml%HDFstrings, HDF)
  do ii=1,biny 
    EBSP(1:binx,ii) = expt((ii-1)*binx+1:ii*binx)
  end do 
  quat = qAR%getQuatfromArray(jj)
  quat = conjg(quat)
  newctmp = quat%quat_Lp_vecarray(numhatn, transpose(ctmp))
  VDpositions(3,jj) =  100000000.D0   ! set to a large value
  call Message%printMessage(' Equivalent diffraction conditions that fall on the EBSP for (EBSDlocx, EBSPlocy) : ')
  do kk=1,numhatn
    mv_line = line(newctmp(1,kk),newctmp(2,kk),newctmp(3,kk))
    mv_line = mv_line%normalized()
    mv = meet(mv_plane, mv_line)
    mv = mv%normalized()
    call getpoint(mv,x,y,z)
    if (z.gt.0.0) then
    ! these are also in units of pixels ... 
      pos(1) = y/dl-0.5D0+dble(DIFT%nml%exptnumsx/2)-DIFT%nml%xpc
      pos(2) = DIFT%nml%L*sa/dl/ca-x/dl/ca-0.5D0+dble(DIFT%nml%exptnumsy/2)+DIFT%nml%ypc
      px = pos(1)
      py = pos(2)
      if ( (px.ge.-xbound) .and. (px.le.xbound) .and. (py.ge.-ybound) .and. (py.le.ybound) ) then 
        VDpx = nint(pos(1)) 
        VDpy = DIFT%nml%exptnumsy - nint(pos(2)) 
        if ( (VDpx.gt.0).and.(VDpx.le.DIFT%nml%exptnumsx).and.(VDpy.gt.0).and.(VDpy.le.DIFT%nml%exptnumsy) ) then 
          dis = sqrt( real( (DIFT%nml%exptnumsx/2-VDpx)**2 + (DIFT%nml%exptnumsy/2-VDpy)**2 ) )
          EBSP(VDpx-2:VDpx+2,VDpy-2:VDpy+2) = maxval(EBSP)
          if ( dis .lt. VDpositions(3,jj) ) then 
            VDpositions(1:3,jj) = (/ pos(1), DIFT%nml%exptnumsy - pos(2), dis /)
            VDkk = kk
            io_int(1:3) = (/ kk, VDpx, VDpy /)
            call Message%WriteValue('  ---> ', io_int, 3)
          end if 
        end if
      end if
    end if
  end do 
! draw the virtual detector position on the diffraction pattern
  VDpxref = nint(VDpositions(1,jj))
  VDpyref = nint(VDpositions(2,jj))
  EBSP(VDpxref-3:VDpxref+3,VDpyref-3:VDpyref+3) = maxval(EBSP)
  call Message%printMessage(' ---> the larger square indicates the position closest to the detector center.')

  sz2 = shape(EBSP)
  call self%drawEBSPpositions_(sz2,EBSP)
 
! we should do this with OpenMP !

  VDpositions(3,:) =  100000000.D0   ! set to a large value
  do jj = 1, Nexp 
    quat = qAR%getQuatfromArray(jj)
    quat = conjg(quat)
    newctmp = quat%quat_Lp_vecarray(numhatn, transpose(ctmp))
    ! do kk=1,numhatn
      mv_line = line(newctmp(1,VDkk),newctmp(2,VDkk),newctmp(3,VDkk))
      mv_line = mv_line%normalized()
      mv = meet(mv_plane, mv_line)
      mv = mv%normalized()
      call getpoint(mv,x,y,z)
      if (z.gt.0.0) then
        pos(1) = y/dl-0.5D0+dble(DIFT%nml%exptnumsx/2)-DIFT%nml%xpc
        pos(2) = DIFT%nml%L*sa/dl/ca-x/dl/ca-0.5D0+dble(DIFT%nml%exptnumsy/2)+DIFT%nml%ypc
        px = pos(1)
        py = pos(2)
        if ( (px.ge.-xbound) .and. (px.le.xbound) .and. (py.ge.-ybound) .and. (py.le.ybound) ) then 
          VDpx = nint(pos(1)) 
          VDpy = DIFT%nml%numsy - nint(pos(2)) 
          if ( (VDpx.gt.0).and.(VDpx.le.DIFT%nml%exptnumsx).and.(VDpy.gt.0).and.(VDpy.le.DIFT%nml%exptnumsy) ) then 
            dis = sqrt( real( (VDpxref-VDpx)**2 + (VDpyref-VDpy)**2 ) )
            ! if ( dis .lt. VDpositions(3,jj) ) then 
              VDpositions(1:3,jj) = (/ pos(1), DIFT%nml%numsy - pos(2), dis /)
            ! end if 
          end if
        end if
      end if
    ! end do
  end do
  call mem%dealloc(newctmp, 'newctmp')
 ! output the VDpositions array for debugging purposes
 ! open(unit=20,file='VDpositions.txt',status='unknown',form='unformatted')
 ! write (20) shape(VDpositions)
 ! write (20) sngl(VDpositions)
 ! close(unit=20,status='keep')
else
! get the lower left corner of the virtual detector
  VDposx = nint(nml%VDlocx) - (nml%VDwidth-1)/2
  VDposy = nint(nml%VDlocy) - (nml%VDheight-1)/2
end if


if (trim(nml%VDtype).ne.'Array') then
! initialize the HiPassFilter routine (has its own FFTW plans)
  allocate(hpmask(binx,biny),inp(binx,biny),outp(binx,biny),stat=istat)
  if (istat .ne. 0) stop 'could not allocate hpmask array'
  call init_HiPassFilter(dble(DIFT%nml%hipassw), (/ binx, biny /), hpmask, inp, outp, HPplanf, HPplanb)
  deallocate(inp, outp)

! this next part is done with OpenMP, with only thread 0 doing the reading;
! Thread 0 reads one line worth of patterns from the input file, then all threads do
! the work; repeat until all patterns have been processed.
  call OMP_setNThreads(nml%nthreads)
  dims3 = (/ binx, biny, nml%ipf_wd /)

  do iii = iiistart,iiiend

! start the OpenMP portion
!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(TID, ival, jj, jjj, kk, Pat, window, VDpx, VDpy, rrdata, ffdata, inp, outp, offset3)

! set the thread ID
   TID = OMP_GET_THREAD_NUM()

   allocate(Pat(binx,biny), window(nml%VDwidth, nml%VDheight))
   allocate(rrdata(binx,biny),ffdata(binx,biny))
   allocate(inp(binx,biny),outp(binx,biny))

! thread 0 reads the next row of patterns from the input file
! we have to allow for all the different types of input files here...
    if (TID.eq.0) then
        offset3 = (/ 0, 0, (iii-1)*nml%ipf_wd /)
        if (ROIselected.eqv..TRUE.) then
          if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) .or. (itype.eq.11) ) then
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, nml%ROI, &
                                     HDFstrings=nml%HDFstrings, HDF=HDF)
          else
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, nml%ROI)
          end if
        else
         if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) .or. (itype.eq.11) ) then
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, &
                                     HDFstrings=nml%HDFstrings, HDF=HDF)
          else
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray)
          end if
        end if
    end if

! other threads must wait until T0 is ready
!$OMP BARRIER    

! then loop in parallel over all patterns to perform the preprocessing steps
!$OMP DO SCHEDULE(DYNAMIC)
    do jj=jjstart,jjend
! convert imageexpt to 2D EBSD Pattern array
        jjj = jj-jjstart+1
        do kk=1,biny
          Pat(1:binx,kk) = exppatarray((jjj-1)*patsz+(kk-1)*binx+1:(jjj-1)*patsz+kk*binx)
        end do

! Hi-Pass filter
        rrdata = dble(Pat)
        ffdata = applyHiPassFilter(rrdata, (/ binx, biny /), dble(DIFT%nml%hipassw), hpmask, inp, outp, HPplanf, HPplanb)
        Pat = sngl(ffdata)

! get the virtual detector coordinates
        if (trim(nml%VDreference).eq.'MPat') then 
          ival = (iii-1)*nml%ipf_wd + jj
          VDpx = nint(VDpositions(1,ival))
          VDpy = nint(VDpositions(2,ival))
        else
          VDpx = VDposx
          VDpy = VDposy
        end if

        window = Pat( VDpx:VDpx+nml%VDwidth-1, VDpy:VDpy+nml%VDheight-1 )
        VDimage(jj-jjstart+1,iii-iiistart+1) = sum( window*VDmask )
    end do
!$OMP END DO

!$OMP BARRIER
  deallocate(Pat, window, rrdata, ffdata, inp, outp)
!$OMP END PARALLEL

  end do

! prepare for image output  
  if (ROIselected.eqv..TRUE.) then
    TIFF_nx = nml%ROI(3)
    TIFF_ny = nml%ROI(4)
  else
    TIFF_nx = nml%ipf_wd
    TIFF_ny = nml%ipf_ht
  end if

  ! allocate memory for image
  allocate(TIFF_image(TIFF_nx,TIFF_ny))

! fill the image with whatever data you have (between 0 and 255)
  ma = maxval(VDimage)
  mi = minval(VDimage)

  do j=1,TIFF_ny
    do i=1,TIFF_nx
      TIFF_image(i,j) = int(255 * (VDimage(i,j)-mi)/(ma-mi))
    end do
  end do
else ! we're doing a regular array of virtual detectors in a single large output image ... 
  numpatx = nml%numsx / nml%VDstep 
  numpaty = nml%numsy / nml%VDstep 
  TIFF_nx = nml%ipf_wd * numpatx
  TIFF_ny = nml%ipf_ht * numpaty
  io_int(1:4) = (/ numpatx, numpaty, TIFF_nx, TIFF_ny /)
  call Message%WriteValue(' preparing to generate ', io_int, 4, '(I3," by ",I3," patterns in image of size ",I6," x ",I6)')
  allocate( TIFF_image(TIFF_nx, TIFF_ny), montage(TIFF_nx, TIFF_ny) ) 

! define the pixel coordinates that need to be used as offsets into the diffraction patterns
  call mem%alloc( VDpos, (/ numpatx * numpaty /), 'VDpositions' )
  do j=1,numpaty
    do i=1,numpatx
      VDpos( (j-1)*numpatx+i ) = nml%ipf_wd*( j*nml%VDstep-1-nml%VDstep/2 ) + &
                                 nml%VDstep * i - nml%VDstep/2 
    end do 
  end do

! read rows of patterns and plug the proper pixels into the montage
  dims3 = (/ binx, biny, nml%ipf_wd /)

  do iii = iiistart,iiiend
    offset3 = (/ 0, 0, (iii-1)*nml%ipf_wd /)
    if (ROIselected.eqv..TRUE.) then
      if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) .or. (itype.eq.11) ) then
        call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, nml%ROI, &
                                 HDFstrings=nml%HDFstrings, HDF=HDF)
      else
        call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, nml%ROI)
      end if
    else
      if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) .or. (itype.eq.11) ) then
        call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, &
                                 HDFstrings=nml%HDFstrings, HDF=HDF)
      else
        call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray)
      end if
    end if

! the VDpositions array lists the 1D positions of the virtual detector array pixels
! and can be used directly as an index into the exppatarray, accounting for the patsz
! offset for each individual pattern    
    do j= jjstart, jjend  ! loop over the patterns in this row
      lll = (j-jjstart) * patsz ! offset of the j-th pattern in the exppatarray
      do jj= 1, numpaty   ! double loop to determine the offset of this virtual detector
        do ii= 1, numpatx ! in the VDpositions array
          kkk = (jj-1) * numpatx + ii
          VDpx = nml%ipf_wd * (ii-1) + j-jjstart+1
          VDpy = nml%ipf_ht * (jj-1) + iii
          montage(VDpx, VDpy) = exppatarray(lll + VDpos(kkk))
        end do
      end do
    end do

  end do

! fill the image with whatever data you have (between 0 and 255)
  ma = maxval(montage)
  mi = minval(montage)

  do j=1,TIFF_ny
    do i=1,TIFF_nx
      TIFF_image(i,j) = int(255 * (montage(i,j)-mi)/(ma-mi))
    end do
  end do

end if 

! output the virtual detector image(s) as a tiff file
fname = trim(EMsoft%generateFilePath('EMdatapathname'))//trim(nml%virtualimagefile)
TIFF_filename = trim(fname)

! set up the image_t structure
im = image_t(TIFF_image)
if(im%empty()) call Message%printMessage("EBSD4D_","failed to convert array to image")

! create the file
call im%write(trim(TIFF_filename), iostat, iomsg) ! format automatically detected from extension
if(0.ne.iostat) then
  call Message%printMessage("failed to write image to file : "//iomsg)
else
  call Message%printMessage(' Virtual detector map written to '//trim(TIFF_filename))
end if

call closeFortranHDFInterface()

end associate

end subroutine EBSD4D_


!--------------------------------------------------------------------------
subroutine EBSD4Dconvol_(self, EMsoft, progname, HDFnames)
!DEC$ ATTRIBUTES DLLEXPORT :: EBSD4Dconvol_
!! author: MDG 
!! version: 1.0 
!! date: 04/15/24
!!
!! perform the computations
!! 
!! This routine performs a convolution of a mask with an EBSD data set and stores
!! the result in an HDF5 file

use mod_EMsoft
use mod_HDFnames
use mod_patterns
use mod_vendors
use mod_filters
use mod_DIfiles
use mod_io
use mod_math
use mod_timing
use mod_FFTW3
use omp_lib
use mod_OMPsupport
use HDF5
use h5im
use h5lt
use mod_HDFsupport
use ISO_C_BINDING
use mod_memory

use, intrinsic :: iso_fortran_env

IMPLICIT NONE 

class(EBSD4D_T), INTENT(INOUT)          :: self
type(EMsoft_T), INTENT(INOUT)           :: EMsoft
character(fnlen), INTENT(INOUT)         :: progname 
type(HDFnames_T), INTENT(INOUT)         :: HDFnames

type(IO_T)                              :: Message
type(HDF_T)                             :: HDF
type(DIfile_T)                          :: DIFT
type(timing_T)                          :: timer
type(memory_T)                          :: mem
type(Vendor_T)                          :: VT
type(HDFnames_T)                        :: saveHDFnames

integer(kind=irg)                       :: L,totnumexpt,imght,imgwd, recordsize, hdferr, TID, iii, &
                                           itype, istat, iiistart, iiiend, jjstart, jjend, binx, biny, sz(3), &
                                           correctsize, dims(2), i, j, k, ii, jj, jjj, kk, patsz, Nexp, numhatn, io_int(3), &
                                           sz2(2), ival
real(kind=sgl)                          :: tstop
integer(kind=ill)                       :: jjpat
logical                                 :: ROIselected
real(kind=sgl),allocatable              :: exppatarray(:), convolpatarray(:,:,:), mask(:,:), Pat(:,:)
integer(HSIZE_T)                        :: dims3(3), offset3(3), hdims(3)
character(fnlen)                        :: fname, datafile, datagroupname, dataset, attributename, DIfile, HDF_FileVersion
real(kind=dbl),allocatable              :: rrdata(:,:), ffdata(:,:), ksqarray(:,:), VDmaskd(:,:)
complex(kind=dbl),allocatable           :: hpmask(:,:)
complex(C_DOUBLE_COMPLEX),allocatable   :: inp(:,:), outp(:,:), convolmask(:,:)
type(C_PTR)                             :: planf, HPplanf, HPplanb
character(11)                           :: dstr
character(15)                           :: tstrb
character(15)                           :: tstre
logical                                 :: insert = .TRUE., overwrite = .TRUE.
character(fnlen,kind=c_char)            :: line2(1)

call openFortranHDFInterface()
HDF = HDF_T()

associate( nml=>self%nml )

! memory class 
mem = memory_T()

! read info from the dot product file
DIfile = trim(EMsoft%generateFilePath('EMdatapathname'))//trim(nml%dotproductfile)
saveHDFnames = HDFnames
call HDFnames%set_NMLfiles(SC_NMLfiles)
call HDFnames%set_NMLfilename(SC_DictionaryIndexingNML)
call HDFnames%set_NMLparameters(SC_NMLparameters)
call HDFnames%set_NMLlist(SC_DictionaryIndexingNameListType)
call DIFT%readDotProductFile(EMsoft, HDF, HDFnames, DIfile, hdferr) 
HDFnames = saveHDFnames 

! copy various constants from the namelist
L = nml%numsx*nml%numsy
totnumexpt = nml%ipf_wd*nml%ipf_ht
imght = nml%numsx
imgwd = nml%numsy
recordsize = L*4
dims = (/ imght, imgwd /)
binx = nml%numsx
biny = nml%numsy

! make sure that correctsize is a multiple of 16; if not, make it so
! this is not really relevant for this program, but several routines 
! rely on this being the case so we impose it here
if (mod(L,16) .ne. 0) then
    correctsize = 16*ceiling(float(L)/16.0)
else
    correctsize = L
end if
patsz = correctsize

ROIselected = .FALSE.
if (sum(nml%ROI).ne.0) ROIselected = .TRUE.

timer = Timing_T()
tstrb = timer%getTimeString()
dstr = timer%getDateString()


if (sum(nml%ROI).ne.0) then
  ROIselected = .TRUE.
  iiistart = nml%ROI(2)
  iiiend = nml%ROI(2)+nml%ROI(4)-1
  jjstart = nml%ROI(1)
  jjend = nml%ROI(1)+nml%ROI(3)-1
else
  ROIselected = .FALSE.
  iiistart = 1
  iiiend = nml%ipf_ht
  jjstart = 1
  jjend = nml%ipf_wd
end if

! allocate the output image array
call mem%alloc(VDmaskd, (/ nml%VDwidth, nml%VDheight /), 'VDmaskd')
call mem%alloc(exppatarray, (/ patsz * nml%ipf_wd /), 'exppatarray')
call mem%alloc(convolpatarray, (/ binx, biny, nml%ipf_wd /), 'convolpatarray')
call mem%alloc(mask, (/ nml%VDwidth, nml%VDheight /), 'mask', initval=0.0)

! make the mask according to the virtual detector type 
select case(nml%VDtype)
  case('Rect')
    VDmaskD = 1.D0
  case('Hann')
    call HannWindow(nml%VDwidth, VDmaskd, dble(nml%VDHannAlpha))

  case default 
    call Message%printError('EBSD4D','virtual detector type not yet implemented')
end select

! initialize the HiPassFilter routine (has its own FFTW plans)
allocate(hpmask(binx,biny),inp(binx,biny),outp(binx,biny),convolmask(binx,biny),stat=istat)
if (istat .ne. 0) stop 'could not allocate hpmask array'
call init_HiPassFilter(dble(DIFT%nml%hipassw), (/ binx, biny /), hpmask, inp, outp, HPplanf, HPplanb)

! get the Fourier transform of the mask (first embed in a full size array padded with 0s)
inp = cmplx(0.D0,0.D0)
! put the mask in the middle and then shift the array
do j=-nml%VDwidth/2,nml%VDwidth/2
 do k=-nml%VDheight/2,nml%VDheight/2
  inp(binx/2+j,biny/2+k) = cmplx(VDmaskd(nml%VDwidth/2+j+1,nml%VDheight/2+k+1),0.D0)
 end do
end do
inp = cshift(inp,binx/2,1)
inp = cshift(inp,biny/2,2)
call fftw_execute_dft(HPplanf, inp, outp)
convolmask = outp
deallocate(inp, outp)

! open the output HDF5 file that will have the convolved patterns in it
! Create a new file using the default properties.
datafile = EMsoft%generateFilePath('EMdatapathname', nml%convolvedpatternfile)

hdferr =  HDF%createFile(datafile)
if (hdferr.ne.0) call HDF%error_check('HDF_createFile ', hdferr)

!====================================
! new in Release 4.3: add a Manufacturer string (null terminated)
dataset = SC_Manufacturer
line2(1) = 'EMsoft'
line2(1) = cstringify(line2(1))
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1)
!====================================

! write the EMheader to the file
datagroupname = trim(HDFnames%get_ProgramData()) ! 'EBSD' or 'TKD'
call HDF%writeEMheader(EMsoft,dstr, tstrb, tstre, progname, datagroupname)

! create a namelist group to write all the namelist files into
hdferr = HDF%createGroup(HDFnames%get_NMLfiles())
if (hdferr.ne.0) call HDF%error_check('HDF_createGroup NMLfiles', hdferr)

! read the text file and write the array to the file
dataset = '4DEBSDNML'
hdferr = HDF%writeDatasetTextFile(dataset, EMsoft%nmldeffile )
if (hdferr.ne.0) call HDF%error_check('HDF_writeDatasetTextFile 4DEBSDNML', hdferr)

call HDF%pop()

! create a NMLparameters group to write all the namelist entries into
hdferr = HDF%createGroup(HDFnames%get_NMLparameters())
if (hdferr.ne.0) call HDF%error_check('HDF_createGroup NMLparameters', hdferr)

call self%writeHDFNameList_(HDF, HDFnames)

! and leave this group
call HDF%pop()

! then the remainder of the data in a EMData group
hdferr = HDF%createGroup(HDFnames%get_EMData())
if (hdferr.ne.0) call HDF%error_check('HDF_createGroup EMData', hdferr)

! create the EBSD group and add a HDF_FileVersion attribute to it
hdferr = HDF%createGroup(datagroupname)
if (hdferr.ne.0) call HDF%error_check('HDF_createGroup 4DEBSD', hdferr)
! before Feb. 19, 2019, an undetected error caused all patterns to be upside down in the Kikuchi bands only,
! not in the background intensity profile.  This was compensated by a pattern flip of all experimental
! patterns in the dictionary indexing program, but when taking individual patterns from this program, they
! are actually upside down in all versions through HDF_FileVersion 4.0.  As of 4.1, the patterns are in the
! correct orientation.  This was detected by manually indexing a simulated pattern.
HDF_FileVersion = '4.1'
attributename = SC_HDFFileVersion
hdferr = HDF%addStringAttributeToGroup(attributename, HDF_FileVersion)

dataset = 'binx'
hdferr = HDF%writeDatasetInteger(dataset, binx)
if (hdferr.ne.0) call HDF%error_check('HDF_writeDatasetInteger binx', hdferr)

dataset = 'biny'
hdferr = HDF%writeDatasetInteger(dataset, biny)
if (hdferr.ne.0) call HDF%error_check('HDF_writeDatasetInteger biny', hdferr)

dataset = 'numpatterns'
hdferr = HDF%writeDatasetInteger(dataset, nml%ipf_wd*nml%ipf_ht)
if (hdferr.ne.0) call HDF%error_check('HDF_writeDatasetInteger numpatterns', hdferr)

offset3 = (/ 0, 0, 0 /)
hdims = (/ binx, biny, nml%ipf_wd*nml%ipf_ht/)
dims3 = (/ binx, biny, nml%ipf_wd /)

dataset = 'ConvolvedPatterns'
hdferr = HDF%writeHyperslabFloatArray(dataset, convolpatarray, hdims, offset3, dims3)
if (hdferr.ne.0) call HDF%error_check('HDF_writeHyperslabFloatArray ConvolvedPatterns', hdferr)

! leave this group and the file open so thread 0 can write to it after each row of patterns

!===================================================================================
! set the vendor inputtype and file name for the pattern file
VT = Vendor_T( nml%inputtype )
itype = VT%get_itype()
call VT%set_filename( nml%exptfile )

!===================================================================================
! open the file with experimental patterns; depending on the inputtype parameter, this
! can be a regular binary file, as produced by a MatLab or IDL script (default); a
! pattern file produced by EMEBSD.f90 etc.; or a vendor binary or HDF5 file... in each case we need to
! open the file and leave it open, then use the getExpPatternRow() routine to read a row
! of patterns into the exppatarray variable ...  at the end, we use closeExpPatternFile() to
! properly close the experimental pattern file
if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) ) then
  HDF = HDF_T()
  istat = VT%openExpPatternFile(EMsoft, nml%ipf_wd, L, recordsize, nml%HDFstrings, HDF)
else
  istat = VT%openExpPatternFile(EMsoft, nml%ipf_wd, L, recordsize)
end if

if (istat.ne.0) then
    call Message%printError("EBSD4D:", "Fatal error handling experimental pattern file")
end if

!==============================
! this next part is done with OpenMP, with only thread 0 doing the reading and writing;
! Thread 0 reads one line worth of patterns from the input file, then all threads do
! the work; repeat until all patterns have been processed.
call OMP_setNThreads(nml%nthreads)
call timer%Time_tick()

do iii = iiistart,iiiend

! start the OpenMP portion
!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(TID, ival, jj, jjj, kk, Pat, rrdata, ffdata, inp, outp, offset3)

! set the thread ID
   TID = OMP_GET_THREAD_NUM()

   allocate(Pat(binx,biny))
   allocate(rrdata(binx,biny),ffdata(binx,biny))
   allocate(inp(binx,biny),outp(binx,biny))

! thread 0 reads the next row of patterns from the input file
! we have to allow for all the different types of input files here...
    if (TID.eq.0) then
        offset3 = (/ 0, 0, (iii-1)*nml%ipf_wd /)
        if (ROIselected.eqv..TRUE.) then
          if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) ) then
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, nml%ROI, &
                                     HDFstrings=nml%HDFstrings, HDF=HDF)
          else
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, nml%ROI)
          end if
        else
         if ( (itype.eq.4) .or. (itype.eq.6) .or. (itype.eq.7) .or. (itype.eq.8) ) then
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray, &
                                     HDFstrings=nml%HDFstrings, HDF=HDF)
          else
            call VT%getExpPatternRow(iii, nml%ipf_wd, patsz, L, dims3, offset3, exppatarray)
          end if
        end if
    end if

! other threads must wait until T0 is ready
!$OMP BARRIER    

! then loop in parallel over all patterns to perform the preprocessing steps
!$OMP DO SCHEDULE(DYNAMIC)
    do jj=jjstart,jjend
! convert imageexpt to 2D EBSD Pattern array
      jjj = jj-jjstart+1
      do kk=1,biny
        Pat(1:binx,kk) = exppatarray((jjj-1)*patsz+(kk-1)*binx+1:(jjj-1)*patsz+kk*binx)
      end do

! Hi-Pass filter and convolution with virtual detector
      rrdata = dble(Pat)
      ffdata = applyHiPassFilter(rrdata, (/ binx, biny /), dble(DIFT%nml%hipassw), hpmask, inp, outp, HPplanf, HPplanb, convolmask)
      Pat = sngl(ffdata)

! and put the convolved pattern in the output array so it can be written to the HDF5 file
      convolpatarray(1:binx, 1:biny, jj) = Pat(1:binx, 1:biny)
    end do
!$OMP END DO

!$OMP BARRIER

! thread 0 writes the convolved patterns to the output HDF5 file 
    if (TID.eq.0) then
      offset3 = (/ 0, 0, (iii-1) * nml%ipf_wd /)
      dataset = 'ConvolvedPatterns'
      hdferr = HDF%writeHyperslabFloatArray(dataset, convolpatarray, hdims, offset3, dims3, insert)
      if (hdferr.ne.0) call HDF%error_check('HDF_writeHyperslabFloatArray ConvolvedPatterns', hdferr)
      if (mod(iii,10).eq.0) then 
        io_int(1:2) = (/ iii, iiiend /)
        call Message%WriteValue(' Completed pattern row ', io_int, 2, "(I4,' out of ', I6)")
      end if 
    end if

!$OMP BARRIER
deallocate(Pat, rrdata, ffdata, inp, outp)
!$OMP END PARALLEL

end do

call timer%Time_tock()
tstop = timer%getInterval()

io_int(1) = tstop
call Message%WriteValue('Execution time [system_clock()] = ',io_int,1,"(I8,' [s]')")

call HDF%pop()
call HDF%pop()

! and update the end time
timer = timing_T()
tstre = timer%getTimeString()

hdferr = HDF%openGroup(HDFnames%get_EMheader())
if (hdferr.ne.0) call HDF%error_check('HDF_openGroup EMheader', hdferr)

hdferr = HDF%openGroup(HDFnames%get_ProgramData())
if (hdferr.ne.0) call HDF%error_check('HDF_openGroup 4DEBSD', hdferr)

! stop time /EMheader/StopTime 'character'
dataset = SC_StopTime
line2(1) = dstr//', '//tstre
hdferr = HDF%writeDatasetStringArray(dataset, line2, 1, overwrite)
if (hdferr.ne.0) call HDF%error_check('HDF_writeDatasetStringArray StopTime', hdferr)

dataset = SC_Duration
hdferr = HDF%writeDatasetFloat(dataset, tstop)
if (hdferr.ne.0) call HDF%error_check('HDF_writeDatasetFloat Duration', hdferr)

! close the datafile
call HDF%popall()

call closeFortranHDFInterface()

end associate

end subroutine EBSD4Dconvol_



end module mod_4DEBSD