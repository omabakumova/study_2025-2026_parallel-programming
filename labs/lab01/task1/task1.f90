program queue
    use iso_fortran_env
    implicit none
    
    integer(int64), parameter :: n = 10  ! 10 пар покупателей
    integer(int64), parameter :: total_trials = 10000  ! Количество испытаний
    integer(int8), allocatable :: Q(:)
    integer :: i, trial, count_success, count_fail
    integer(int64) :: current_sum
    real :: probability, theoretical_prob
    logical :: success
    character(len=100) :: filename
    integer :: file_unit
    
    ! Инициализация генератора случайных чисел
    call random_seed()
    
    ! Выделение памяти для очереди
    if (.not. allocated(Q)) allocate(Q(2*n))
    
    ! Открываем файл для записи данных графика (только для первой успешной траектории)
    filename = "trajectory_data.txt"
    open(newunit=file_unit, file=filename, status='replace')
    
    count_success = 0
    count_fail = 0
    
    ! Основной цикл испытаний
    trials_loop: do trial = 1, total_trials
        
        ! Заполняем очередь (n единиц и n минус единиц)
        do i = 1, 2*n
            Q(i) = merge(1_int8, -1_int8, i <= n)  ! Первые n - рубли, остальные - 50 копеек
        end do
        
        ! Перемешиваем очередь
        call shuffle_queue(Q)
        
        ! Проверяем траекторию
        current_sum = 0
        success = .true.
        
        do i = 1, 2*n
            current_sum = current_sum + Q(i)
            
            ! Если сумма стала положительной - кто-то ждет сдачу
            if (current_sum > 0) then
                success = .false.
                count_fail = count_fail + 1
                exit
            end if
        end do
        
        ! Если траектория успешная
        if (success) then
            count_success = count_success + 1
            
            ! Записываем данные первой успешной траектории для графика
            if (count_success == 1) then
                current_sum = 0
                do i = 1, 2*n
                    current_sum = current_sum + Q(i)
                    write(file_unit, *) i, current_sum
                end do
            end if
        end if
        
    end do trials_loop
    
    ! Закрываем файл
    close(file_unit)
    
    ! Вычисляем вероятность
    probability = real(count_success) / real(total_trials)
    theoretical_prob = 1.0 / (n + 1)
    
    ! Вывод результатов
    print *, "Результаты моделирования:"
    print *, "Длина очереди: ", 2*n
    print *, "Количество испытаний: ", total_trials
    print *, "Успешных траекторий: ", count_success
    print *, "Вероятность (моделирование): ", probability
    print *, "Теоретическая вероятность: ", theoretical_prob
    print *, "Данные для графика записаны в файл: ", trim(filename)
    
    ! Освобождаем память
    if (allocated(Q)) deallocate(Q)
    
contains
    
    subroutine shuffle_queue(Q)
        implicit none
        integer(int8), dimension(:), intent(inout) :: Q
        integer(int8) :: itemp
        real :: u
        integer :: i, j, m, k
        
        m = size(Q)
        
        do k = 1, 2  ! Двойное перемешивание для случайности
            do i = 1, m
                call random_number(u)
                j = 1 + floor(m * u)  ! Случайный индекс от 1 до m
                itemp = Q(j)
                Q(j) = Q(i)
                Q(i) = itemp
            end do
        end do
    end subroutine shuffle_queue

end program queue
