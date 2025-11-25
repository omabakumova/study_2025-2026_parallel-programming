include "../src/random.f90"

program test_montyhall
  use iso_fortran_env
  use random
  implicit none
  include "omp_lib.h"

  integer(int64) :: i
  integer(int64), parameter :: number_of_turns = 10**9
  integer(int64) :: victories, local_victories
  real(real64) :: win_rate_with_alt, win_rate_without_alt
  integer :: thread_id, num_threads

  open(unit=10, file='montyhall_results.csv', status='replace')
  write(10, '(A)') "strategy,win_rate"

  ! Получаем количество доступных потоков
  num_threads = omp_get_max_threads()
  print *, "Используется потоков:", num_threads
  print *, "Количество испытаний:", number_of_turns

  ! Игрок всегда меняет выбор
  victories = 0
  !$omp parallel private(i, local_victories) reduction(+:victories)
  local_victories = 0
  !$omp do
  do i = 1, number_of_turns
    local_victories = local_victories + monty(.true.)
  end do
  !$omp end do
  victories = victories + local_victories
  !$omp end parallel

  win_rate_with_alt = dble(victories) / dble(number_of_turns)
  write(10, '(A,",",F10.8)') "change_choice", win_rate_with_alt

  ! Игрок не меняет выбора
  victories = 0 
  !$omp parallel private(i, local_victories) reduction(+:victories)
  local_victories = 0
  !$omp do
  do i = 1, number_of_turns
    local_victories = local_victories + monty(.false.)
  end do
  !$omp end do
  victories = victories + local_victories
  !$omp end parallel

  win_rate_without_alt = dble(victories) / dble(number_of_turns)
  write(10, '(A,",",F10.8)') "keep_choice", win_rate_without_alt

  close(10)

  print "(1(A))", "# 1: количество испытаний" // &
                & "# 2: частота выигрыша при смене выбора" // &
                & "# 3: частота выигрыша без смены выбора"
  print "(*(G0,:','))", number_of_turns, win_rate_with_alt, win_rate_without_alt

end program test_montyhall
