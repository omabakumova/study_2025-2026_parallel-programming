program vectorize_loop
    implicit none
    real, dimension(7) :: a, b
    real :: result
    integer :: i
    
    a = [2.0, 3.0, 5.0, 7.0, 11.0, 13.0, 17.0]
    b = [4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0]
    
    ! Явный цикл для скалярного произведения
    result = 0.0
    do i = 1, 7
        result = result + a(i) * b(i)
    end do
    
    print *, result
    print *, dot_product(a, b)

end program
