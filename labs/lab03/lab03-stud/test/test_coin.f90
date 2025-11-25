include "../src/random.f90"

program dice
  use random
  use iso_fortran_env
  implicit none
  include "omp_lib.h"

  integer(int64), parameter :: turns_num = 10**9
  integer(int64) :: turn
  integer :: dice_result
  integer :: counts(1:6) = 0  ! Счетчики для граней 1-6
  real(real64) :: probabilities(1:6)
  integer :: num_ths
  character(len=30) :: argv
  integer :: file_unit

  ! количество потоков получаем как аргумент командной строки
  if (command_argument_count() > 0) then
    call get_command_argument(1, argv)
    read(argv, *) num_ths
  else
    ! если ничего не передано, то 
    num_ths = omp_get_max_threads()
  end if
  
  print "('Количество потоков: ', I0)", num_ths
  print "('Количество испытаний: ', I0)", turns_num

  !$omp parallel num_threads(num_ths) private(turn, dice_result)
  !$omp do reduction(+ : counts)
  !  используется функция из random.f90 randomint
  do turn = 1, turns_num
    dice_result = randomint(6)  ! случайное число от 1 до 6
    counts(dice_result) = counts(dice_result) + 1
  end do
  !$omp end do
  !$omp end parallel

  ! Вычисляем вероятности
  probabilities = dble(counts) / dble(turns_num)

  print *, ""
  print *, "Результаты эксперимента:"
  do turn = 1, 6
    print "('Грань ', I1, ': количество = ', I12, ', вероятность = ', F8.6)", &
          turn, counts(turn), probabilities(turn)
  end do

  print *, ""
  print *, "Теоретическая вероятность для каждой грани: 0.166667"
  print *, ""
  
  ! Проверка равномерности
  print *, "Проверка равномерности распределения:"
  print *, "Максимальное отклонение от теоретического значения: ", &
           maxval(abs(probabilities - 1.0_real64/6.0_real64))
  
  ! Стандартное отклонение
  print "('Стандартное отклонение: ', F10.8)", &
        sqrt(sum((probabilities - 1.0_real64/6.0_real64)**2) / 6.0_real64)

  ! Сохранение результатов в файл для построения графика
  open(newunit=file_unit, file='dice_results.csv', status='replace')
  write(file_unit, '(A)') 'Грань,Количество,Вероятность'
  do turn = 1, 6
    write(file_unit, '(I1,",",I12,",",F8.6)') turn, counts(turn), probabilities(turn)
  end do
  close(file_unit)
  print *, ""
  print *, "Результаты сохранены в файл dice_results.csv"

end program dice
