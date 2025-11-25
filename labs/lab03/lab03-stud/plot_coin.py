#! /usr/bin/env python
#-*- coding:utf-8 -*-

import sys
import numpy as np
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

# Чтение данных из файла
faces, counts, probabilities = np.loadtxt('dice_results.csv', delimiter=',', 
                                         skiprows=1, unpack=True)

fig01 = plt.figure(num=1, figsize=(8, 4), dpi=600)
ax01 = fig01.add_subplot(1, 1, 1)

# Столбчатая диаграмма для вероятностей
bars = ax01.bar(faces, probabilities, width=0.6, alpha=0.7, color='skyblue', 
                edgecolor='navy', linewidth=0.5)

# Добавление теоретической вероятности
theoretical_prob = 1.0/6.0
ax01.axhline(y=theoretical_prob, color='red', linestyle='--', linewidth=1, 
             label=f'Теоретическая вероятность ({theoretical_prob:.6f})')

# Настройки графика
ax01.set_xlabel("Грань кубика")
ax01.set_ylabel("Вероятность")
ax01.set_title("Распределение вероятностей выпадения граней кубика")
ax01.set_xticks(faces)
ax01.legend()

# Добавление значений на столбцы
for bar, prob in zip(bars, probabilities):
    height = bar.get_height()
    ax01.text(bar.get_x() + bar.get_width()/2., height + 0.001,
             f'{prob:.6f}', ha='center', va='bottom', fontsize=8)

fig01.savefig('dice_probabilities.png', dpi=600, format='png', 
              bbox_inches='tight', pad_inches=0.1)

# Дополнительный график - количества выпадений
fig02 = plt.figure(num=2, figsize=(8, 4), dpi=600)
ax02 = fig02.add_subplot(1, 1, 1)

bars2 = ax02.bar(faces, counts, width=0.6, alpha=0.7, color='lightgreen', 
                 edgecolor='darkgreen', linewidth=0.5)

ax02.set_xlabel("Грань кубика")
ax02.set_ylabel("Количество выпадений")
ax02.set_title("Количество выпадений каждой грани кубика")
ax02.set_xticks(faces)

# Добавление значений на столбцы (в миллионах для удобства чтения)
for bar, count in zip(bars2, counts):
    height = bar.get_height()
    ax02.text(bar.get_x() + bar.get_width()/2., height + turns_num*0.001,
             f'{count/1e6:.1f}M', ha='center', va='bottom', fontsize=8)

fig02.savefig('dice_counts.png', dpi=600, format='png', 
              bbox_inches='tight', pad_inches=0.1)

plt.show()
