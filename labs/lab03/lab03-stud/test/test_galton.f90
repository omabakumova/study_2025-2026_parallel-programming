include "../src/random.f90"

program test_galton
  use random
  use iso_fortran_env
  implicit none
  include "omp_lib.h"
  ! количество испытаний методом Монте-Карло
  integer(int64), parameter :: number_of_turns = 10**6
  integer(int64), parameter :: hight = 10
  integer(int64), parameter :: n = 100
  
  integer(int64) :: turn
  integer(int64),allocatable :: galton(:)
  ! Нижняя строка треугольника Паскаля для 10
  integer(int64) :: pascal(0:10)
  ! Оптимально количество потоков
  integer :: optimal_threads_num


  optimal_threads_num = omp_get_max_threads()

  pascal = [1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1]

  if (.not.allocated(galton)) then
    allocate(galton(0:hight))
  end if

  galton = 0

  !$omp parallel num_threads(optimal_threads_num)
  !$omp do reduction(+ : galton)
  do turn = 1,number_of_turns,1
    galton = galton + galton_board(hight, n)
  end do
  !$omp end do
  !$omp end parallel

  print "(*(I0, :, '  '))", galton
  print "(*(G0, :, /))", galton / dble(n * number_of_turns)
  print "('Сумма частот: ', G0)", sum(galton / dble(n * number_of_turns))
  print "(*(G0, :, /))", pascal / dble(sum(pascal))

  deallocate(galton)

end program test_galton