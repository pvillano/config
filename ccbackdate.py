import base64
import datetime
import urllib.parse

def strplus(s, i):
    return str(int(s) + i)

def main():
    # inp = input()
    inp = """"""
    unquoted = urllib.parse.unquote(inp)
    trimmed = unquoted.removesuffix("!END!")
    decoded = base64.urlsafe_b64decode(trimmed)
    as_str = decoded.decode()
    chapters = list(map(lambda l: l.split(';'),as_str.split("|", )))


    indexes = [[2,[0,1,2]],[4,[44]]]
    for chapter_index, page_indexes in indexes:
        for page_index in page_indexes:
            original = chapters[chapter_index][page_index]
            as_date = datetime.datetime.fromtimestamp(float(original)/1000)
            offset = as_date.replace(year=datetime.datetime.now().year - 50)
            as_unix = str(int(offset.timestamp() * 1000))
            chapters[chapter_index][page_index] = as_unix

    version, reserved, run_details, preferences, misc, buildings, upgrades, achievements, buffs, *rest = chapters


    for i in range(len(buildings)):
        if not buildings[i]:
            continue
        owned, bought, produced, level, minigame, muted, highest = buildings[i].split(',')
        n = str(10**10)
        owned = n
        bought = n
        # level = '100'
        highest = n
        buildings[i] = ','.join([owned, bought, produced, level, minigame, muted, highest])

    misc[4] =strplus(misc[3], 100000)
    misc[12] = '999999'
    misc[14] = '999999'

    chapters = [version, reserved, run_details, preferences, misc, buildings, upgrades, achievements, buffs, *rest]
    as_str = '|'.join(map(lambda l: ';'.join(l), chapters))
    encoded = base64.urlsafe_b64encode(as_str.encode())
    untrimmed = encoded.decode() + "!END!"
    quoted = urllib.parse.quote(untrimmed)
    print(quoted)

if __name__ == '__main__':
    main()
