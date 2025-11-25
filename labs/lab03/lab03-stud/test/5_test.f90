program token_game
  use iso_fortran_env, only: int64, real64
  use omp_lib              
  use random
  implicit none

  integer :: x0 = 3, y0 = 4, z0 = 5
  integer(int64) :: n_trials = 1000000_int64

  integer :: n_threads, tid, i, iunit
  integer(int64), allocatable :: rounds_per_thread(:)
  integer(int64) :: total_rounds
  real(real64) :: avg_rounds, theoretical

  n_threads = omp_get_max_threads()
  allocate(rounds_per_thread(0:n_threads-1))
  rounds_per_thread = 0_int64

  !$omp parallel default(none) shared(rounds_per_thread, n_trials, x0, y0, z0) private(i, tid)
  tid = omp_get_thread_num()
  !$omp do schedule(dynamic)
  do i = 1, n_trials
    rounds_per_thread(tid) = rounds_per_thread(tid) + simulate_game(x0, y0, z0)
  end do
  !$omp end do
  !$omp end parallel

  total_rounds = sum(rounds_per_thread)
  avg_rounds = real(total_rounds, real64) / real(n_trials, real64)

  theoretical = real(x0 * y0 * z0, real64) / real(x0 + y0 + z0 - 2, real64)
  
  ! Сохранение результатов в CSV файл
  open(newunit=iunit, file='game_results.csv', status='replace', action='write')
  write(iunit, '(A)') 'x0,y0,z0,n_trials,experimental,theoretical,relative_error'
  write(iunit, '(I0,A,I0,A,I0,A,I0,A,F12.6,A,F12.6,A,ES12.4)') &
        x0, ',', y0, ',', z0, ',', n_trials, ',', avg_rounds, ',', theoretical, ',', abs(avg_rounds - theoretical) / theoretical
  close(iunit)

  print *, 'Экспериментальное среднее количество раундов = ', avg_rounds
  print *, 'Теоретическое значение = ', theoretical
  print *, 'Относительная погрешность = ', abs(avg_rounds - theoretical) / theoretical
  print *, 'Результаты сохранены в файл game_results.csv'

contains

  function simulate_game(x, y, z) result(rounds)
    implicit none
    integer, intent(in) :: x, y, z
    integer(int64) :: rounds
    integer :: a, b, c, winner

    a = x; b = y; c = z
    rounds = 0_int64

    do while (a > 0 .and. b > 0 .and. c > 0)
      rounds = rounds + 1_int64
      winner = randomint(3)
      select case (winner)
        case (1)
          a = a + 2; b = b - 1; c = c - 1
        case (2)
          b = b + 2; a = a - 1; c = c - 1
        case (3)
          c = c + 2; a = a - 1; b = b - 1
      end select
    end do
  end function simulate_game

end program token_game
