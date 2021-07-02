subroutine print_climo(io6,grids,i_counts,i_size,c_year,work_month,&
                       lat_range,lon_range)
!
!  NAME:
!
!  PURPOSE:
!
!  CALLS:
!    None
!
!  MODIFICATIONS:
!    Blake Sorenson <blake.sorenson@und.edu>     - 2021/06/10: Written
!
!  ###########################################################################

  implicit none

  integer                :: io6
  real                   :: grids(360,i_size)
  integer                :: i_counts(360,i_size)
  integer                :: i_size        ! array size
  character(len = 4)     :: c_year
  integer                :: work_month
  real,dimension(i_size) :: lat_range
  real,dimension(360)    :: lon_range

  integer        :: ii
  integer        :: jj

  ! # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 
  !write(*,*) "In print_climo"

  ! Loop over the grid and count up grids with high AI
  do ii=1,i_size
    do jj=1,360
      write(io6,'(a10,3(a8))') 'Date','LatxLon','AvgAI','Count'
      write(io6,'(a10,3(a8))') 'Date','LatxLon','AvgAI','Count'
    enddo  
  enddo  

  if(synop_times(synop_idx) < 12) then
    write(io6,'(a9,i1,5(i6))') dtg(1:8)//'0',synop_times(synop_idx),&
      ai_count_65,ai_count_70,ai_count_75,ai_count_80,ai_count_85
  else
    write(io6,'(a8,i2,5(i6))') dtg(1:8),synop_times(synop_idx), &
      ai_count_65,ai_count_70,ai_count_75,ai_count_80,ai_count_85
  endif    

  ! Reset grid arrays
  grids(:,:) = 0.
  i_counts(:,:) = 0

end subroutine print_climo
