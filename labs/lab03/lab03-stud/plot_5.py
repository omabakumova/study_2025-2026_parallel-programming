#! /usr/bin/env python
#-*- coding:utf-8 -*-

import sys
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

plt.rcParams.update({
  "font.serif": ['Times New Roman'],
  "font.sans-serif": ['Arial'],
  "font.family": 'serif',
  # не использовать настройки шрифтов самого matplotlib
  "pgf.rcfonts": False,
  "pgf.texsystem": 'xelatex',
  "xtick.minor.visible": True,
  "ytick.minor.visible": True,
  "axes.grid": True,
  "axes.grid.which": 'both',
  "grid.linewidth": 0.25,
  "grid.linestyle": 'dashed',
  "grid.color": 'gray',
})

# Чтение данных из CSV файла
data = pd.read_csv('game_results.csv')

# Извлечение данных
x0 = data['x0'][0]
y0 = data['y0'][0]
z0 = data['z0'][0]
experimental = data['experimental'][0]
theoretical = data['theoretical'][0]
relative_error = data['relative_error'][0]

# Создание графика
fig01 = plt.figure(num=1, figsize=(8, 6), dpi=300)
ax01 = fig01.add_subplot(1, 1, 1)

# Данные для графика - сравнение экспериментального и теоретического значений
categories = ['Экспериментальное', 'Теоретическое']
values = [experimental, theoretical]

bars = ax01.bar(categories, values, color=['lightblue', 'lightgreen'], alpha=0.7)
ax01.axhline(y=theoretical, color='red', linestyle='--', alpha=0.7, label=f'Теоретическое = {theoretical:.6f}')

# Добавление значений на столбцы
for bar, value in zip(bars, values):
    height = bar.get_height()
    ax01.text(bar.get_x() + bar.get_width()/2., height + 0.1,
             f'{value:.6f}', ha='center', va='bottom')

ax01.set_ylabel('Среднее количество раундов')
ax01.set_title(f'Сравнение экспериментального и теоретического значений\n(x0={x0}, y0={y0}, z0={z0}, n_trials={data["n_trials"][0]})')
ax01.legend()

# Добавление информации об ошибке
ax01.text(0.02, 0.98, f'Относительная погрешность: {relative_error:.2e}', 
          transform=ax01.transAxes, verticalalignment='top',
          bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

fig01.savefig('game_results.png', dpi=300, format='png', bbox_inches='tight', pad_inches=0.3)
fig01.savefig('game_results.pgf', dpi=300, format='pgf', bbox_inches='tight', pad_inches=0.3)

print(f"График сохранен как 'game_results.png' и 'game_results.pgf'")
print(f"Экспериментальное значение: {experimental:.6f}")
print(f"Теоретическое значение: {theoretical:.6f}")
print(f"Относительная погрешность: {relative_error:.2e}")
