! <OwnDataTypes_ml.f90 - A component of the EMEP MSC-W Unified Eulerian
!          Chemical transport Model>
!*****************************************************************************! 
!* 
!*  Copyright (C) 2010-2011 met.no
!* 
!*  Contact information:
!*  Norwegian Meteorological Institute
!*  Box 43 Blindern
!*  0313 OSLO
!*  NORWAY
!*  email: emep.mscw@met.no
!*  http://www.emep.int
!*  
!*    This program is free software: you can redistribute it and/or modify
!*    it under the terms of the GNU General Public License as published by
!*    the Free Software Foundation, either version 3 of the License, or
!*    (at your option) any later version.
!* 
!*    This program is distributed in the hope that it will be useful,
!*    but WITHOUT ANY WARRANTY; without even the implied warranty of
!*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!*    GNU General Public License for more details.
!* 
!*    You should have received a copy of the GNU General Public License
!*    along with this program.  If not, see <http://www.gnu.org/licenses/>.
!*****************************************************************************! 
module OwnDataTypes_ml
implicit none

  ! depmap
  ! gtype for species groups, used in CM_ChemSpecs and Derived

  public :: print_deriv_type
  integer, public, parameter :: TXTLEN_DERIV = 34
  integer, public, parameter :: TXTLEN_SHORT = 28

  ! Contains some user-defined data-types, and routine associated
  ! with these. Collecting them here will
  ! avoid some dependencies, and shorten some My type modules.
  !
  ! depmap used in DryDep_ml and My_WetDep_ml
  ! Deriv used in My_Derived and  Derived_ml
  ! VBST from SOA_ml

  !/-- we define a type to map indices of species to be deposited
  !   to the lesser number of species where Vg is calculated

  type, public :: depmap
    integer :: ind   ! Index of species in IXADV_ or IX_ arrays
    integer :: calc  ! Index of species in  calculated dep arrays
    real    :: vg    ! if CDDEP_SET, give vg in m/s
  end type depmap

  !==================
  !/ generic group for two integers
  type, public :: typ_i2
    integer :: int1
    integer :: int2
  end type typ_i2

  type, public :: typ_i3
    integer :: int1
    integer :: int2
    integer :: int3
  end type typ_i3

  !/ generic group for two (short) strings
  type, public :: typ_ss
    character(len=TXTLEN_SHORT) :: txt1 ! e.g. POD1_IAM_DF
    character(len=TXTLEN_SHORT) :: txt2 ! e.g. POD1_IAM_DF
  end type typ_ss

  !/ generic group for name and pointer to arrays
  type, public :: typ_sp
    character(len=TXTLEN_SHORT) :: name ! e.g. POD1_IAM_DF
    integer, dimension(:), pointer :: ptr
  end type typ_sp

  !/ generic group for three (short) strings
  type, public :: typ_s3
    character(len=TXTLEN_SHORT) :: txt1
    character(len=TXTLEN_SHORT) :: txt2
    character(len=TXTLEN_SHORT) :: txt3
  end type typ_s3

  !/ generic group for four (short) strings
  type, public :: typ_s4
    character(len=TXTLEN_SHORT) :: txt1 ! e.g. POD1_IAM_DF
    character(len=TXTLEN_SHORT) :: txt2 ! e.g. POD1_IAM_DF
    character(len=TXTLEN_SHORT) :: txt3 ! e.g. POD1_IAM_DF
    character(len=TXTLEN_SHORT) :: txt4 ! e.g. POD1_IAM_DF
  end type typ_s4

  !/ generic group for five (short) strings
  type, public :: typ_s5i
    character(len=TXTLEN_SHORT) :: txt1 ! e.g.  SO2
    character(len=TXTLEN_SHORT) :: txt2 ! e.g.  ugS
    character(len=TXTLEN_SHORT) :: txt3 ! e.g.  2d
    character(len=TXTLEN_SHORT) :: txt4 ! e.g.  "AIR_CONC"
    character(len=TXTLEN_SHORT) :: txt5 ! e.g.  M
    integer                     :: ind  ! e.g.  IOU_DAY
  end type typ_s5i

  !==================
  !+ Derived output type
  type, public:: Deriv
    character(len=TXTLEN_DERIV) :: name     ! e.g. DDEP_SO2_m2Conif
    character(len=TXTLEN_SHORT) :: class    ! Type of data, e.g. ADV or Mosaic
    character(len=TXTLEN_SHORT) :: subclass !  e.g. "VG", "Rns"
    character(len=TXTLEN_SHORT) :: txt      ! text where needed, e.g. "Conif"
    character(len=TXTLEN_SHORT) :: unit     ! writen in netCDF output
    integer  :: index         ! index in concentation array, or other
    integer :: f2d            ! index in f_2d arrays
    logical :: dt_scale       ! used only if we need a factor on dt_advec,
    real    :: scale          !  e.g. use 100.0 to get cm/s
    logical  :: avg           ! True => average data (divide by nav at end),
                              !  else accumulate over run period
    integer  :: iotype        ! sets output timing
  end type

  !==================
  !+ Hourly ASCII/NetCDF output type
  type, public:: Asc2D
    character(len=TXTLEN_DERIV):: name ! Name (no spaces!)
    character(len=TXTLEN_SHORT):: type ! "ADVppbv" or "ADVugm3" or "SHLmcm3"
    character(len=9) :: ofmt      ! Output format (e.g. es12.4)
    integer          :: spec      ! Species number in xn_adv or xn_shl array
                                  ! or other arrays
    integer          :: ix1,ix2   ! bottom-left,upper-right x
    integer          :: iy1,iy2   ! bottom-left,upper-right y
    integer          :: nk        ! number of vertical levels
    character(len=TXTLEN_SHORT) :: unit   ! Unit used
    real             :: unitconv   !  conv. factor
    real             :: max         ! Max allowed value for output
  end type

  !==================
  !+ Defines SOA, NONVOL and VBS params
  type, public :: VBST
       integer     :: index    ! just for clarity
       real        :: CiStar   ! ug/m3
      !real        :: Tref    ! Assumed 300
       real        :: DeltaH   ! kJ/mole
  end type VBST

contains
 !=========================================================================

subroutine print_Deriv_type(w)
  type(Deriv), intent(in) :: w  ! wanted

  write(6,*) "Prints Deriv type ========================="
  write(6,"(a,a)")      "Name   :",    trim(w%name)
  write(6,"(a,a)")      "class  :",    trim(w%class)
  write(6,"(a,a)")      "subclass  :", trim(w%subclass)
  write(6,"(a,a)")      "txt    :",    trim(w%txt)
  write(6,"(a,a)")      "units  :",    trim(w%unit)
  write(6,"(a,i3)")     "index  :", w%index
  write(6,"(a,i3)")     "f2d    :", w%f2d
  write(6,"(a,a10)")    "txt    :", w%txt
  write(6,"(a,es10.3)") "scale  :", w%scale
  write(6,*)        "dt_scale:", w%dt_scale
  write(6,*)        "avg:",      w%avg
end subroutine print_Deriv_type

 !=========================================================================
end module OwnDataTypes_ml
