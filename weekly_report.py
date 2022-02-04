#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  4 17:55:01 2021

@author: TienTong

This script generates stats for the weekly report specifically.

But you can also ask it to save a csv file with an added race label
(which includes mixed race) by uncommenting out line 74

"""

import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None

file = 'CURRENTK23BachiMenta-WeeklyRecruitmentSta_DATA_2022-01-28_1608.csv' # CHANGE THIS

def weekly_report(file, out=None):
    df = pd.read_csv(file)
    df.head()

    def label_race (row):
      if (row['race___white'] + row['race___aa'] + row['race___asian'] +
          row['race___hawaiin_pacific_island'] + row['race___american_indian'] +
          row['race___alaskan'] > 1) :
          return 'mixed'
      elif row['race___white'] ==1 :
          return 'white'
      elif row['race___aa'] ==1 :
          return 'black'
      elif row['race___asian'] ==1 :
          return 'asian'
      elif row['race___hawaiin_pacific_island'] ==1 :
          return 'hawaiian'
      elif row['race___american_indian'] ==1 :
          return 'american indian'
      elif row['race___alaskan'] ==1 :
          return 'alaskan'

    df = pd.read_csv(file)
    df_complete = df[df['study_completion_status'] == 'completer']
    df_complete['race_label'] = df_complete.apply(lambda row: label_race(row), axis=1)
    df_complete_cud = df_complete[df_complete['ie_enrollment_cud_v_hc'] == 'CUD']
    df_complete_hc = df_complete[df_complete['ie_enrollment_cud_v_hc'] == 'HC']

    ctq_median = np.median(df_complete.ctq_total_score_2)

    if out is not None:
        df_complete.to_csv(out)

    return df_complete, df_complete_hc, df_complete_cud, ctq_median


def get_infor(group, data):
    print("\n" + group + " Age Mean: " + str(np.mean(data.age_years)))
    print(group + " Age STDV: " + str(np.std(data.age_years)))
    print(group + " N Male: " + str(np.sum(data.sex == 'male')))
    print(group + " N Female: " + str(np.sum(data.sex == 'female')))
    print("\n" + group + " Edu Mean: " + str(np.mean(data.asi_education)))
    print(group + " Edu STDV: " + str(np.std(data.asi_education)))
    print(data['race_label'].value_counts())
    print("\n" + group + " CTQ: ")
    print(data["ctq_total_score_2"].describe())
    print("\n" +  group + " Speech: " + str(np.sum(data.ibm_speech_complete == 2)))
    print("\n" +  group + " Motivation: " + str(np.count_nonzero(data.agency_motivation_date.dropna())))
    print(group + " Motivation old: " + str(np.sum(data.agency_motivation_task_version == 'old')))
    print("\n" + group + " N low trauma: " + str(np.sum(data.ctq_total_score_2 < ctq_median)))
    print(group + " N high trauma: " + str(np.sum(data.ctq_total_score_2 >= ctq_median)))

df_complete, df_complete_hc, df_complete_cud, ctq_median = weekly_report(
    # out = 'race_label.csv',
    file=file)

print("Whole sample N: " + str(df_complete.shape[0]))
print("CUD N: " + str(df_complete_cud.shape[0]))
print("HC N: " + str(df_complete_hc.shape[0]))
print("\nWhole sample CTQ:")
print(df_complete["ctq_total_score_2"].describe())

get_infor(group = 'HC', data = df_complete_hc)
get_infor(group = 'CUD', data = df_complete_cud)
