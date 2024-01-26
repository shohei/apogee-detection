#!/usr/bin/env python
# coding: utf-8

import streamlit as st

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from ipywidgets import interact, interactive, fixed, interact_manual
import ipywidgets as widgets
import tempfile
from PIL import Image

st.title("Apogee detection by N-3 rocket")


df = pd.read_csv('tanafull.csv')
# Trim the data frame
# Kalman filtered Altitude
df2 = df['filtered_s'][1600:]
# See the data looks like
#df2.plot()

# Apogee detection algorithm 1
# If there is 5 times consecutive decrease in altitude, it is recognized as the apogee.
def detect(xs,MAX_COUNT):
    last = xs[0]
    # MAX_COUNT = 1
    indicator = MAX_COUNT
    print(indicator,end=',')
    for i,cur in enumerate(xs[1:]):
        if (cur > last):
            if (indicator < MAX_COUNT):
                indicator = MAX_COUNT
                print(indicator,end=',')
        if (cur < last):
            indicator -= 1
            print(indicator,end=',')
            if indicator == 0:
                print()
                print("Apogee detected at {0} frame. Apogee: {1} [m]".format(i+1,cur))
                return(i+1,cur)
        last = cur


# sampling_period = 0.2 #200ms
sampling_period = 0.074 #74ms

# Test the logic
alt = np.array(df2)
true_apogee_index = np.argmax(alt)
true_apogee = max(alt)
counters=[]
delay_frames=[]
delays=[]
for i in [5,4,3,2,1]:
    [frame,apogee] = detect(alt, i)
    delay = (frame-true_apogee_index)*sampling_period
    delay_frame = frame-true_apogee_index
    print("Delay frames: {0}:".format(delay_frame))
    print("Delay second: {0:.2f}[sec]".format(delay))
    delay_frames.append(delay_frame)
    delays.append(delay)
dic = {"count": [5,4,3,2,1], "delays [sec]": delays, "delay_frames": delay_frames}
delay_df = pd.DataFrame(data=dic)


fig, ax = plt.subplots(1, 1,figsize=(10,6))
alt = np.array(df2)
n_sample = len(alt)
t = np.arange(0,n_sample*sampling_period,sampling_period)
ax.plot(t,alt, label="Kalman-filtered altitude data (N-2 Tana Rocket)")

COUNT = st.slider("How many consecutive decrease?", 1, 10, 5)
f1 = st.empty()

#COUNT = 5
[frame,apogee] = detect(alt, COUNT)
x = sampling_period*frame
y = df2.iloc[frame]
ax.plot(x,y,'bo', label="Detected apogee")

x2 = sampling_period*true_apogee_index
y2 = true_apogee
ax.plot(x2,y2,'rx',label="True apogee")

ax.legend()

plt.xlabel('Elapsed time[sec]')
plt.ylabel('Altitude[m]')
plt.title("Apogee detection ({0} consectuve decrease)".format(COUNT))

figure_tmp_name = tempfile.NamedTemporaryFile().name+'fig1.png'
fig.savefig(figure_tmp_name)
fig_image = Image.open(figure_tmp_name)
f1.image(fig_image)
#plt.show()
