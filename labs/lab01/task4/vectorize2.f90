program vectorize_dynamic
    implicit none
    real, allocatable, dimension(:) :: a, b
    real :: result
    integer :: i, n = 7
    
    allocate(a(n), b(n))
    
    a = [2.0, 3.0, 5.0, 7.0, 11.0, 13.0, 17.0]
    b = [4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0]

    ! Встроенные функции
    print *, sum(a*b)
    print *, dot_product(a, b)
    
    deallocate(a, b) ! освобождение динамически выделенной памяти
end program
