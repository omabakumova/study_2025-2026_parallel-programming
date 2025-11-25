# Requires -PSEdition Core

$tasks = $args

$BINDIR = 'bin'
$TESTDIR = 'test'
$MODDIR = 'mod'

if ($args.count -eq 0) {
  $tasks = @(
    'birthdays', 'montyhall', 'random_walk', 'tokens_game'
    )
}

switch($tasks) {
  'birthdays' {
    <#
    ! Программы по парадоксу дней рожденья нет! Вам ее надо реализовать по
    ! аналогии с задачей о парадоксе Монти Холла
    #>
    gfortran -fopenmp -Wall $TESTDIR/test_birthdays.f90 -o $BINDIR/birthdays.exe -J $MODDIR
    2..50 | ForEach-Object { bin/birthdays $_} | python .\plot_birthdays_rate.py
  }
  'montyhall' {
    gfortran -fopenmp -Wall $TESTDIR/test_montyhall.f90 -o $BINDIR/montyhall.exe -J $MODDIR
  }
  'coin' {
    gfortran -fopenmp -Wall $TESTDIR/test_coin.f90 -o $BINDIR/test_coin.exe -J $MODDIR
  }
  'random_walk' {
    gfortran -fopenmp -Wall $TESTDIR/test_random_walk.f90 -o $BINDIR/random_walk.exe -J $MODDIR
  }
  'tokens_game' {
    <#
    ! Программы по игре с жетонами нет! Вам ее надо реализовать по
    ! аналогии с задачей о разорении (одномерном блуждании)
    #>
    gfortran -fopenmp -Wall $TESTDIR/test_tokens_game.f90 -o $BINDIR/tokens_game.exe -J $MODDIR
  }
  'galton' {
    gfortran -fopenmp -Wall $TESTDIR/test_galton.f90 -o $BINDIR/galton.exe -J $MODDIR
  }
  'clean' {
    Get-ChildItem -Include ('*.mod', '*.exe') -Recurse | ForEach-Object { Remove-Item -Path $_.FullName -Verbose }
  }
}