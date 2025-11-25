#!/usr/bin/env python
# -*- coding:utf-8 -*-

import pandas as pd
from matplotlib import pyplot as plt

plt.rcParams.update({
    "font.serif": ['Times New Roman'],
    "font.sans-serif": ['Arial'],
    "font.family": 'serif',
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

data = pd.read_csv('random_walk_results.csv')

start_sum = data['start_sum'].iloc[0]
winrate = data['winrate'].iloc[0]
avg_rounds = data['avg_rounds'].iloc[0]
avg_rounds_theoretical = data['avg_rounds_theoretical'].iloc[0]
diff = data['diff'].iloc[0]

fig = plt.figure(figsize=(8, 5), dpi=300)
ax = fig.add_subplot(1, 1, 1)

labels = ['Эмпирическое среднее', 'Теоретическое среднее']
values = [avg_rounds, avg_rounds_theoretical]
colors = ['lightblue', 'lightgreen']

bars = ax.bar(labels, values, color=colors, alpha=0.8)

for bar, val in zip(bars, values):
    ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.5,
            f'{val:.2f}', ha='center', va='bottom')

ax.set_ylabel('Среднее число раундов')
ax.set_title(f'Случайное блуждание: старт = {start_sum}, p = 0.45\nЧастота выигрыша = {winrate:.6f}')

fig.savefig('random_walk_results.png', dpi=300, format='png', bbox_inches='tight', pad_inches=0.2)
fig.savefig('random_walk_results.pgf', dpi=300, format='pgf', bbox_inches='tight', pad_inches=0.2)

plt.show()
