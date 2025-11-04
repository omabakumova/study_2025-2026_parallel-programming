program cards_probability
    implicit none
    
    integer, parameter :: num_cards = 36
    integer, parameter :: num_aces = 4
    integer, parameter :: num_trials = 100000
    character(len=5), parameter :: original_deck(1:36) = [character(len=5) :: &
        "T♠","K♠","Д♠","В♠","6♠","7♠","8♠","9♠","10♠", &
        "T♥","K♥","Д♥","В♥","6♥","7♥","8♥","9♥","10♥", &
        "T♦","K♦","Д♦","В♦","6♦","7♦","8♦","9♦","10♦", &
        "T♣","K♣","Д♣","В♣","6♣","7♣","8♣","9♣","10♣"]
    
    integer :: i, trial
    integer :: count_A = 0      ! Счетчик события A (вторая карта - туз)
    integer :: count_B = 0      ! Счетчик события B (первая карта - туз)
    integer :: count_AB = 0     ! Счетчик события AB (обе карты - тузы)
    real :: prob_A, prob_A_given_B
    
    ! Рабочий массив колоды
    character(len=5) :: deck(1:36)
    
    ! Инициализация генератора случайных чисел
    call random_seed()
    
    ! Основной цикл испытаний
    do trial = 1, num_trials
        ! Копируем оригинальную колоду в рабочую
        deck = original_deck
        
        ! Перемешиваем колоду
        call shuffle_deck(deck)
        
        ! Событие A: вторая карта - туз
        if (is_ace(deck(2))) then
            count_A = count_A + 1
        end if
        
        ! Событие B: первая карта - туз
        if (is_ace(deck(1))) then
            count_B = count_B + 1
        end if
        
        ! Событие AB: обе карты - тузы
        if (is_ace(deck(1)) .and. is_ace(deck(2))) then
            count_AB = count_AB + 1
        end if
    end do
    
    prob_A = real(count_A) / real(num_trials)
    prob_A_given_B = real(count_AB) / real(count_B)
    
    print *, 'Результаты моделирования (', num_trials, ' испытаний):'
    print *, '--------------------------------------------------'
    print *, 'Безусловная вероятность P(A):'
    print *, 'Теоретическая: ', 4.0/36.0
    print *, 'Экспериментальная: ', prob_A
    print *, '--------------------------------------------------'
    print *, 'Условная вероятность P(A|B):'
    print *, 'Теоретическая: ', 3.0/35.0
    print *, 'Экспериментальная: ', prob_A_given_B
    print *, '--------------------------------------------------'
    print *, 'Количество событий:'
    print *, 'A (вторая карта - туз): ', count_A
    print *, 'B (первая карта - туз): ', count_B
    print *, 'AB (обе карты - тузы): ', count_AB
    
contains

! Функция для проверки, является ли карта тузом
logical function is_ace(card)
    character(len=*), intent(in) :: card
    is_ace = (card(1:1) == 'T')  ! Тузы обозначены буквой 'T'
end function is_ace

! Подпрограмма для перемешивания колоды
subroutine shuffle_deck(deck)
    implicit none
    character(len=*), dimension(:), intent(inout) :: deck 
    character(len=len(deck(1))) :: temp ! длина берется от 1-го элемента массива
    real :: u
    integer :: i, j, n, m, k
    
    n = 1
    m = size(deck)
    
    do k = 1, 2
        do i = 1, m
            call random_number(u)
            j = n + floor((m + 1 - n) * u)
            temp = deck(j) ! карта из случайно позиции j  во временную переменную
            deck(j) = deck(i)
            deck(i) = temp
        end do
    end do
end subroutine shuffle_deck

end program cards_probability
