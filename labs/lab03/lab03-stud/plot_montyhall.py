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

# Чтение данных Монти-Холла
data = pd.read_csv('montyhall_results.csv')

strategies = data['strategy']
win_rates = data['win_rate']

fig01 = plt.figure(num=1, figsize=(8, 5), dpi=300)
ax01 = fig01.add_subplot(1, 1, 1)

# Создаем столбчатую диаграмму
bars = ax01.bar(strategies, win_rates, color=['lightblue', 'lightcoral'], alpha=0.7)

# Добавляем значения на столбцы
for bar, rate in zip(bars, win_rates):
    height = bar.get_height()
    ax01.text(bar.get_x() + bar.get_width()/2., height + 0.01,
             f'{rate:.4f}', ha='center', va='bottom')

# Теоретические значения для сравнения
ax01.axhline(y=2/3, color='blue', linestyle='--', alpha=0.5, label='Теоретическая вероятность (смена выбора)')
ax01.axhline(y=1/3, color='red', linestyle='--', alpha=0.5, label='Теоретическая вероятность (сохранение выбора)')

ax01.set_ylabel("Вероятность выигрыша")
ax01.set_title("Вероятность выигрыша в задаче Монти-Холла")
ax01.set_ylim(0, 1.0)
ax01.legend()

# Сохраняем графики
fig01.savefig('montyhall_results.png', dpi=300, format='png', bbox_inches='tight', pad_inches=0.2)
fig01.savefig('montyhall_results.pgf', dpi=300, format='pgf', bbox_inches='tight', pad_inches=0.2)

plt.show()
