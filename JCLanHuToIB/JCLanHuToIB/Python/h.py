#!/usr/bin/env python
# -- coding: UTF-8 --

from bs4 import BeautifulSoup
import os, sys
import json

text = sys.argv[1]

dic = {}
bs = BeautifulSoup(text, 'html.parser')
container = bs.find('div', attrs={'class': 'annotation_container lanhu_scrollbar flag-ps'})
item1 = container.find('div', attrs={'class':"annotation_item"})


# 图层
def layer_item_li(li):
	t = li.find('div', attrs={'class':'item_title'})
	title = t.text.strip()
	one = li.find('div', attrs={'class':'item_one'})
	if one:
		return (title, one.text.strip())
	else:
		two = li.find_all('div', attrs={'class':'item_two'})
		L = []
		for div in two:
			L.append(div.text.strip())
		return (title, L)

def layer_item():
	for li in item1.find_all('li'):
		title, value = layer_item_li(li)
		if title == '图层':
			dic['name'] = value
		elif title == '位置':
			dic['x'] = value[0].replace('pt', '')
			dic['y'] = value[1].replace('pt', '')
		elif title == '大小':
			dic['width'] = value[0].replace('pt', '')
			dic['height'] = value[1].replace('pt', '')
		elif title == '不透明度':
			dic['opaque'] = float(value.replace('%', '')) / 100.0
		elif title == '圆角':
			dic['round'] = value.replace('pt', '')

layer_item()

# UI信息

item2 = container.find('div', attrs={'class':"annotation_item 2"})

def ui_info_li(li):
	t = li.find('div', attrs={'class':'item_title'})
	title = t.text.strip()

	one = li.find('div', attrs={'class':'item_one'})
	if one:
		return (title, one.text.strip())

	align_text = li.find('div', attrs={'class': 'align_text'})
	if align_text:
		return (title, align_text.text.strip())

	copy_text = li.find('span', attrs={'class': 'copy_text'})
	if copy_text:
		for x in li.find_all('div', attrs={'class': 'color-item'}):
			if 'RGBA' in x.span.text:
				rgba = x.p.text.strip().replace('RGBA', '')
				return (title, rgba.split(','))		

	font = li.find('div', attrs={'class': 'two'})
	if font:
		return (title, font.text.strip())

	content = li.find('div', attrs={'class': 'item_one item_content'})
	if content:
		return (title, content.text.strip())

def ui_info():
	item = item2
	if item == None:
		item = container.find('div', attrs={'class':"annotation_item 1"})
		if item == None:
			return

	for li in item.find_all('li'):
		title, value = ui_info_li(li)
		if title == '字体':
			dic['font'] = value
		elif title == '字重':
			dic['weight'] = value
		elif title == '对齐':
			dic['align'] = value
		elif title == '颜色':
			dic['color_r'] = value[0]
			dic['color_g'] = value[1]
			dic['color_b'] = value[2]
			dic['color_a'] = value[3]
		elif title == '字号':
			dic['font_size'] = value.replace('pt', '')
		elif title == '内容':
			dic['text'] = value

ui_info()

print(json.dumps(dic))
#print(dic)
#print(text)
