module trapezoidal_rule
  use iso_fortran_env, only : int32, int64, real32, real64
  implicit none

  abstract interface
    ! Абстрактный интерфейс для подинтегральной функции
    pure function f(x)
      double precision, intent(in) :: x
      double precision :: f
    end function f
  end interface

  private

  public :: trapezoidal

  contains
  !----------------------------------------------------------------
  ! Функция вычисляющая значение интеграла по формуле трапеции
  ! Функция func --- подынтегральная функция от одного аргумента
  ! Параметры a и b задают пределы интегрирования
  ! Параметр n --- число точек разбиения отрезка [a, b]
  ! Параметра threads_num --- число потоков, которые может использовать
  ! функция
  !----------------------------------------------------------------
  function trapezoidal(func, a, b, n, threads_num) result (res)
    implicit none
    procedure(f) :: func
    real(real64), intent(in) :: a, b
    integer(int64), intent(in) :: n
    integer(int64), intent(in) :: threads_num
    real(real64) :: res
    
    real(real64) :: h, sum_val
    integer(int64) :: i
    
    h = (b - a) / n
    
    ! Инициализируем сумму с граничными точками
    sum_val = 0.5_real64 * (func(a) + func(b)) ! это половины значений на концах отрезка.
    
    !$omp parallel do num_threads(int(threads_num)) &
    !$omp reduction(+:sum_val)
    do i = 1, n-1
    	sum_val = sum_val + func(a + i * h)
    end do
    !$omp end parallel do
    res = h * sum_val ! Умножаем накопленную сумму на шаг h — получаем приближённое значение интеграла
    
  end function trapezoidal

end module trapezoidal_rule
