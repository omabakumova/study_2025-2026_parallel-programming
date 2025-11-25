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
    procedure(f) :: func ! должна быть чистой функцией одной переменной
    real(real64), intent(in) :: a, b
    integer(int64), intent(in) :: n
    integer(int64), intent(in) :: threads_num
    real(real64) :: res

    real(real64) :: h ! шаг интегрирования
    real(real64) :: sum_val ! накопительная сумма
    integer(int64) :: i
    
    ! Вычисление шага
    h = (b - a) / dble(n)
    ! Инициализация суммы. Здесь сразу добавляются граничные члены с коэффициентом 0.5.
    sum_val = 0.5_real64 * func(a) + 0.5_real64 * func(b)
    ! Параллельный цикл для суммы внутренних точек с редукцией
    !$omp parallel do num_threads(int(threads_num)) reduction(+:sum_val)
    do i = 1, n-1
    !  накопительной сумме значение подынтегральной функции func, вычисленное в одной из внутренних точек разбиения отрезка интегрирования [a,b] 
      sum_val = sum_val + func(a + real(i, real64) * h)
    end do
    !$omp end parallel do
    res = h * sum_val
  end function trapezoidal

end module trapezoidal_rule
