program test_random_walk
  use random
  use stats
  use iso_fortran_env
  implicit none
  include "omp_lib.h"

  ! Параметры
  integer(int64), parameter :: number_of_turns = 10**7
  integer, parameter :: min_sum = 0
  integer, parameter :: max_sum = 100
  integer, parameter :: start_sum = 90
  real, parameter :: p = 0.45

  ! Переменные для результатов
  real(real64) :: avg, winrate, avg_rounds, diff
  integer(int64) :: rounds
  logical(1) :: win

  ! Переменные для параллельного выполнения
  integer(int64) :: wins_count, total_rounds
  integer(int64) :: i, thread_id
  integer :: num_threads

  !--- НИЖЕ ТОЛЬКО исполняемые операторы ---
  wins_count = 0
  total_rounds = 0

  num_threads = omp_get_max_threads()
  print "('число потоков: ', i0)", num_threads

  !$omp parallel private(i, rounds, win, thread_id) reduction(+:wins_count, total_rounds)
  thread_id = omp_get_thread_num()
  !$omp do
  do i = 1, number_of_turns
    call random_walk_1d(min_sum, max_sum, start_sum, p, rounds, win)
    total_rounds = total_rounds + rounds
    if (win) wins_count = wins_count + 1
    if (mod(i, number_of_turns/20) == 0 .and. thread_id == 0) then
      write(*, "(G0)", advance="no") "."
    end if
  end do
  !$omp end do
  !$omp end parallel

  print *, ""

  avg = real(total_rounds, real64) / real(number_of_turns, real64)
  winrate = real(wins_count, real64) / real(number_of_turns, real64)
  avg_rounds = random_walk_avg_rounds(p, start_sum, max_sum)
  diff = abs(avg - avg_rounds)

  print "('частота выигрыша: ', f10.8)", winrate
  print "('средняя продолжительность игры: ', f10.2)", avg
  print "('теоретическая средняя: ', f10.2)", avg_rounds
  print "('разница: ', f10.2)", diff

  ! === Запись в CSV ===
  open(unit=10, file='random_walk_results.csv', status='replace', action='write')
  write(10, '(a)') 'start_sum,winrate,avg_rounds,avg_rounds_theoretical,diff'
  write(10, '(i0, ",", f0.10, ",", f0.4, ",", f0.4, ",", f0.4)') &
      start_sum, winrate, avg, avg_rounds, diff
  close(10)

end program test_random_walk
