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


people_num, birthday_rate = np.loadtxt(sys.stdin, delimiter=',', usecols=(0,1), comments='#', unpack=True)

fig01 = plt.figure(num=1, figsize=(6, 3), dpi=300)
ax01 = fig01.add_subplot(1, 1, 1)


ax01.step(people_num, birthday_rate)

ax01.set_xlabel("Количество человек в группе")
ax01.set_ylabel("Частота совпадения дней рождений")


fig01.savefig('birthday_rate.png', dpi=300, format='png', bbox_inches='tight', pad_inches=0.0)
fig01.savefig('birthday_rate.pgf', dpi=300, format='pgf', bbox_inches='tight', pad_inches=0.0)
