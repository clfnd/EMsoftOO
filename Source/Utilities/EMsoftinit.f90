! ###################################################################
! Copyright (c) 2016-2020, Marc De Graef Research Group/Carnegie Mellon University
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

program EMsoftinit
  !! author: MDG
  !! version: 1.0 
  !! date: 01/26/20
  !!
  !! first time EMsoft run
  !!
  !! EMsoft calls the EMsoft_path_init routine which takes care of 
  !! creating the configuration file if it does not already exist.  This is
  !! a simplification of the installation process; one less thing to do for 
  !! users who prefer not to create json files manually...

use mod_kinds
use mod_global 
use mod_EMsoft 

IMPLICIT NONE

character(fnlen)    :: progname = 'EMsoftinit'
character(fnlen)    :: progdesc = 'Initialize the EMsoft configuration file'

type(EMsoft_T)      :: EMsoft

write (*,*) ' Important Note :'
write (*,*) ' '
write (*,*) ' This program requires that the EMSOFTPATHNAME variable be defined '
write (*,*) ' '

EMsoft = EMsoft_T( progname, progdesc, makeconfig=.TRUE. )

end program EMsoftinit