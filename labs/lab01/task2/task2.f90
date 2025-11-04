program dice_probability
    implicit none
    
    integer, parameter :: n_trials = 1000000  ! Количество испытаний
    integer :: i, dice1, dice2, sum_dice
    integer :: count_B = 0, count_A_and_B = 0
    real :: prob_A_given_B, theoretical_prob
    
    ! Инициализация генератора случайных чисел
    call random_seed()
    
    ! Моделирование бросания костей
    do i = 1, n_trials
        ! Генерация случайных чисел для двух костей
        call random_dice(dice1)
        call random_dice(dice2)
        
        sum_dice = dice1 + dice2
        
        ! Проверка события B (четная сумма)
        if (mod(sum_dice, 2) == 0) then
            count_B = count_B + 1
            
            ! Проверка события A (сумма = 8)
            if (sum_dice == 8) then
                count_A_and_B = count_A_and_B + 1
            end if
        end if
    end do
    
    ! Вычисление условной вероятности
    if (count_B > 0) then
        prob_A_given_B = real(count_A_and_B) / real(count_B)
    else
        prob_A_given_B = 0.0
    end if
    
    theoretical_prob = 5.0 / 18.0  ! Теоретическое значение
    
    print *, 'Моделирование вероятности P(A|B)'
    print *, '================================'
    print *, 'Количество испытаний: ', n_trials
    print *, 'Количество событий B (четная сумма): ', count_B
    print *, 'Количество событий A∩B (сумма = 8 и четная): ', count_A_and_B
    print *, '--------------------------------'
    print *, 'Экспериментальная вероятность P(A|B): ', prob_A_given_B
    print *, 'Теоретическая вероятность P(A|B): ', theoretical_prob
    print *, 'Абсолютная ошибка: ', abs(prob_A_given_B - theoretical_prob)
    print *, 'Относительная ошибка: ', abs(prob_A_given_B - theoretical_prob) / theoretical_prob * 100, '%'
    
contains

    ! Подпрограмма для генерации случайного числа от 1 до 6 (бросок кости)
    subroutine random_dice(dice_value)
        integer, intent(out) :: dice_value ! переменная будет выходным результатом
        real :: r ! вещественная переменная r для хранения числа от 0.0 до 1.0
        
        call random_number(r)
        dice_value = 1 + floor(6 * r)
    end subroutine random_dice

end program dice_probability
