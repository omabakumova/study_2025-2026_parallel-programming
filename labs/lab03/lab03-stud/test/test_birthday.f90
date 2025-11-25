program birthday_paradox
  use random
  use stats
  use omp_lib
  implicit none

  integer, parameter :: num_tests = 10**6
  integer, parameter :: min_people = 2, max_people = 100
  integer :: n, i, tid, num_threads
  real(8) :: prob
  integer(8) :: count_collisions
  integer, allocatable :: birthdays(:)
  real(8) :: start_time, end_time

  open(unit=20, file='result.csv', status='replace', action='write')

  print *, "Парадокс дней рождения (Монте-Карло)"
  print *, "Испытаний на точку:", num_tests
  print *, "Количество потоков:", omp_get_max_threads()

  print *, " n   |  Вероятность совпадения"

  do n = min_people, max_people
    count_collisions = 0

    !$omp parallel private(i, birthdays, tid) reduction(+:count_collisions)
    allocate(birthdays(n))
    !$omp do
    do i = 1, num_tests
      call generate_birthdays(n, birthdays)
      if (has_duplicate(birthdays)) then
        count_collisions = count_collisions + 1
      end if
    end do
    !$omp end do
    deallocate(birthdays)
    !$omp end parallel

    prob = real(count_collisions, 8) / num_tests
    print "(I4, ' | ', F8.6)", n, prob
    
    write(20, "(I0, ',', F10.8)") n, prob
  end do


  close(20)

  print *, "Результаты сохранены в result.csv"

contains

  ! Генерация дней рождения для n человек
  subroutine generate_birthdays(n, birthdays)
    integer, intent(in) :: n
    integer, intent(out) :: birthdays(n)
    integer :: j
    do j = 1, n
      birthdays(j) = randomint(365)
    end do
  end subroutine

  ! Проверка на наличие повторяющихся дней
  logical function has_duplicate(arr)
    integer, intent(in) :: arr(:)
    integer :: i, j
    has_duplicate = .false.
    do i = 1, size(arr) - 1
      do j = i + 1, size(arr)
        if (arr(i) == arr(j)) then
          has_duplicate = .true.
          return
        end if
      end do
    end do
  end function

end program birthday_paradox
