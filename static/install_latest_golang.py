import lxml.html as lh
from lxml import etree
import requests
import platform
import subprocess

PLATFORM = platform.system().lower()


def get_tr_tag_content_from_html():
    url = "https://golang.org/dl/"
    response = requests.get(url).content
    doc = lh.fromstring(response)
    return doc.xpath('//td')


def latest_go_version():
    trs = get_tr_tag_content_from_html()
    items = []
    for tr in trs:
        if tr.attrib.get('class') == 'filename':
            item = tr.text_content().split('-')[0]
            if PLATFORM in item and 'tar.gz' in tr.text_content():
                items.append(tr.text_content())

    for item in items:
        if '386' in item:
            items.remove(item)

    return items[0]


def download_file(filename):
    url = 'https://dl.google.com/go/' + filename
    r = requests.get(url, allow_redirects=True)
    open(filename, 'wb').write(r.content)


name = latest_go_version()
download_file(name)
subprocess.call(['tar', '-C', '/usr/local', '-xzf', name])
