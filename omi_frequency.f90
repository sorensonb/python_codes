program omi_frequency
!
! NAME:
!   omi_frequency.f90
!
! PURPOSE:
!   Calculate counts of high-AI (w.r.t. a user-defined threshold) quarter
!   degree grid-boxes for AI perturbations averaged into 4 +/- 3hr windows 
!   (00, 06, 12, and 18). Since these codes read AI data directly from the 
!   HDF5 files, the hdf5 module is required.
! 
! CALLS:
!   Subroutines:
!     - count_ai
!     - read_shawn_file
!     - synop_time_check
!
! MODIFICATIONS:
!   Blake Sorenson <blake.sorenson@und.edu>     - 2021/07/09:
!     Written
!
!  ############################################################################

  implicit none

  integer                :: ii            ! loop counter
  integer                :: synop_idx     ! index of current synoptic time
  integer                :: i_size        ! array size
  integer                :: int_hr        ! integer variable for hour
  integer                :: arg_count     ! Number of arguments passed to exec

  real                   :: ai_thresh     ! threshold AI value
  real                   :: lat_thresh    ! latitude threshold. Only analyze
                                          ! data north of this value.
  real                   :: lat_gridder   ! Used for setting up the latitude
                                          ! grid

  logical                :: l_in_time     ! used to determine if the current
                                          ! hour falls within the synoptic time
                                          ! range.

  real,dimension(:), allocatable      :: lat_range ! latitude grid
  real,dimension(:), allocatable      :: lon_range ! longitude grid
  real,dimension(:,:), allocatable    :: grids     ! quarter-degree AI grid
                                                   ! values.
  integer,dimension(:,:), allocatable :: i_counts  ! quarter-degree AI counts

  integer,dimension(4)   :: synop_times     ! list containing the 4 synoptic
                                            ! times

  ! File read variables
  integer,parameter      :: io8    = 42   ! File object for file name file
  integer,parameter      :: io7    = 22   ! File object for each data file 
  integer,parameter      :: io6    = 1827 ! Data output file
  integer,parameter      :: errout = 9 
  integer                :: istatus

  character(len = 255)   :: data_path       ! path to data files
  character(len = 12)    :: dtg             ! dtg from each line of file
  character(len = 255)   :: out_file_name   ! output file name
  character(len = 255)   :: date_file_name  ! name of file containing the 
                                            ! list of shawn file names to 
                                            ! be analyzed

  ! # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  ! Check command line arguments
  ! ----------------------------
  arg_count = command_argument_count()
  if(arg_count /= 2) then
    write(*,*) 'SYNTAX: ./omi_exec out_file_name date_file_name'
  endif

  call get_command_argument(1,out_file_name)
  call get_command_argument(2,date_file_name)

  ! Set up the synoptic time list
  ! -----------------------------
  synop_times = [0,6,12,18] 
  synop_idx = 1

  !data_path = "/Research/OMI/out_files-monthly.20210518/"
  data_path = "/Research/OMI/out_files-monthly_test/"

  ! Set up lat/lon grids
  ! --------------------
  lat_thresh = 65.
  lat_gridder = lat_thresh * 4.
  i_size = (90. - lat_thresh) * 4.
  allocate(lat_range(i_size))
  do ii=1,i_size
    lat_range(ii) = lat_thresh + (ii-1)*0.25
  enddo

  allocate(lon_range(1440))
  do ii=1,1440
    lon_range(ii) = -180.0 + (ii-1)*0.25
  enddo

  ! Initialize grid arrays and set to 0 initially
  ! ----------------------------------------------

  allocate(grids(1440,i_size))
  allocate(i_counts(1440,i_size))

  grids(:,:) = 0.
  i_counts(:,:) = 0

  ! open debug file
  ! ---------------
  open(errout, file = "omi_error.txt", iostat = istatus)
  if(istatus /= 0) then
    write(*,*) "error opening error file."
  endif

  ! open output file
  ! ---------------
  open(io6, file = trim(out_file_name), iostat = istatus)
  if(istatus /= 0) then
    write(errout,*) "ERROR: error opening data count output file."
  endif
  write(io6,'(a10,5(a6))') 'Date','Cnt65','Cnt70','Cnt75','Cnt80','Cnt85'
 
  ! Set up count variables to count the number of grid boxes with
  ! high AI values
  ! -------------------------------------------------------------
  ai_thresh = 0.6

  ! Read the file names from the file name file
  open(io8, file = trim(date_file_name), iostat = istatus)
  if(istatus > 0) then
    write(errout,*) "ERROR: Problem reading "//trim(date_file_name)
    return 
  else
    ! Loop over the dtg file
    ! ----------------------------
    file_loop: do
      ! Read the current dtg from the file
      ! ----------------------------------
      read(io8, *, iostat=istatus) dtg
      if(istatus < 0) then 
        write(*,*) "End of "//trim(date_file_name)//" found"
        exit
      else if(istatus > 0) then
        write(errout,*) "ERROR: problem reading dtg"
        cycle file_loop
      else

        ! Extract time information from dtg
        ! ---------------------------------
        read(dtg(9:10), *) int_hr

        ! See if the hour exceeds the current 6 hr assimilation window.
        ! If so, calculate averages and counts and reset variables.
        ! ------------------------------------------------------------
        call synop_time_check(synop_idx, int_hr, l_in_time)
        if(.not. l_in_time) then 
          call count_ai(io6,grids,i_counts,i_size,ai_thresh,synop_idx,&
                        dtg,lat_range)
        endif  

        ! Open the shawn file and look at contents
        open(io7, file = trim(data_path)//dtg, iostat = istatus)
        if(istatus /= 0) then
          write(errout, *) "ERROR: error opening file",trim(data_path)//dtg
          write(errout, *) "       cycling file_loop"
          cycle file_loop
        endif

        ! Read data from the current file and insert into the grids
        ! ---------------------------------------------------------
        call read_shawn_file(io7,errout,trim(data_path)//dtg,grids,i_counts,&
                             i_size,lat_gridder,lat_thresh)

        ! Close the current shawn file
        ! ----------------------------
        close(io7)
      endif
    enddo file_loop  
  endif

  ! Deallocate the remaining allocated arrays and close all files
  ! -------------------------------------------------------------
  deallocate(grids)
  deallocate(i_counts)
  deallocate(lat_range)
  deallocate(lon_range)
  close(io8)
  close(io6)
  close(errout)  
  
end program omi_frequency
