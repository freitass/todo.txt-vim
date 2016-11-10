#!/usr/bin/env python
# -*- coding: utf-8 -*-
# File:        before.py
# Author:      Guilherme Victal <guilherme at victal.eti.br>
# Description: Generates regexes before a certain date
# License:     Vim license
# Website:     http://github.com/freitass/todo.txt-vim
# Version:     0.1

from datetime import date, timedelta, MINYEAR

def _year_regex_before(year):
    if int(year) <= MINYEAR:
        return None
    year_regex = r'('
    year_regex += r'\d{1,%s}' % str(len(year) - 1) if len(year) > 1 else ''
    for idx, digit in enumerate(year):
        if digit != '0':
            regex = '|' + year[0:idx]
            regex += '0' if digit == '1' else '[0-%s]' % str(int(digit) - 1)
            if idx < len(year) - 1:
                regex += '\d{%s}' % (len(year) - (idx + 1))
            year_regex += regex

    year_regex += ')'
    return '-'.join((year_regex, r'\d{2}', r'\d{2}'))

def _month_regex_before(year, month):
    if month == '01':
        return None

    digit1, digit2 = month
    if digit1 == '0':
        month_regex = '01' if month == '02' else r'0[1-%s]' % str(int(digit2) - 1)
    elif month == '10':
        month_regex = r'0\d'
    elif month == '11':
        month_regex = r'(0\d|10)'
    else:
        month_regex = r'(0\d|1[01])'

    return '-'.join((year, month_regex, r'\d{2}'))

def _day_regex_before(year, month, day):
    if day == '01':
        return None
    last_month_day = str((date(int(year), int(month) % 12 + 1, 1) + - date.resolution).day)
    last_digit1, last_digit2 = last_month_day

    digit1, digit2 = day
    if digit1 == '0':
        day_regex = '01' if day == '02' else r'0[1-%s]' % str(int(digit2) - 1)
    else:
        day_regex = r'('
        day_regex += '0' if digit1 == '1' else r'[0-%s]' % str(int(digit1) - 1)
        day_regex += r'\d'
        if digit2 != '0':
            day_regex += '|'
            day_regex += digit1
            day_regex += '0' if digit2 == '1' else r'[0-%s]' % str(int(digit2) - 1)
        day_regex += ')'

    return '-'.join((year, month, day_regex))




def regex_date_before(given_date):
    year, month, day = given_date.isoformat().split('-')

    year_regex = _year_regex_before(year)
    month_regex = _month_regex_before(year, month)
    day_regex = _day_regex_before(year, month, day)

    date_regex = '(' + year_regex if year_regex else '('
    date_regex += ('|' + month_regex) if month_regex else ''
    date_regex += ('|' + day_regex) if day_regex else ''
    date_regex += ')'
    return date_regex
