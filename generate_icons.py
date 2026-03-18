#!/usr/bin/env python3
"""Generate PWA icons using only stdlib (no Pillow needed)"""
import struct, zlib, os

def png_chunk(chunk_type, data):
    c = chunk_type + data
    return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)

def create_icon_png(size, filename):
    bg = (24, 95, 165)      # --blue
    coin = (255, 210, 80)   # gold

    pixels = []
    cx, cy = size // 2, size // 2
    r_outer = int(size * 0.38)
    r_inner = int(size * 0.22)
    pad = int(size * 0.10)

    for y in range(size):
        row = []
        for x in range(size):
            dx, dy = x - cx, y - cy
            dist = (dx*dx + dy*dy) ** 0.5

            # Rounded rect background
            corner = int(size * 0.18)
            in_bg = (pad <= x < size-pad and pad <= y < size-pad and
                     not (x < pad+corner and y < pad+corner and (x-pad-corner)**2+(y-pad-corner)**2 > corner**2) and
                     not (x > size-pad-corner-1 and y < pad+corner and (x-(size-pad-corner-1))**2+(y-pad-corner)**2 > corner**2) and
                     not (x < pad+corner and y > size-pad-corner-1 and (x-pad-corner)**2+(y-(size-pad-corner-1))**2 > corner**2) and
                     not (x > size-pad-corner-1 and y > size-pad-corner-1 and (x-(size-pad-corner-1))**2+(y-(size-pad-corner-1))**2 > corner**2))

            if in_bg:
                if dist < r_outer:
                    # coin circle
                    t = dist / r_outer
                    shade = int(255 * (1 - t * 0.15))
                    gold = (min(255, coin[0]), min(255, int(coin[1] * shade / 255)), min(80, coin[2]))
                    if dist < r_inner:
                        # inner highlight: €
                        row += [gold[0], gold[1], gold[2], 255]
                    else:
                        row += [gold[0], gold[1], gold[2], 255]
                else:
                    row += [bg[0], bg[1], bg[2], 255]
            else:
                row += [0, 0, 0, 0]
        pixels.append(row)

    # Build PNG
    raw = b''
    for row in pixels:
        raw += b'\x00' + bytes(row)
    compressed = zlib.compress(raw, 9)

    png = b'\x89PNG\r\n\x1a\n'
    png += png_chunk(b'IHDR', struct.pack('>IIBBBBB', size, size, 8, 6, 0, 0, 0))
    png += png_chunk(b'IDAT', compressed)
    png += png_chunk(b'IEND', b'')

    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'wb') as f:
        f.write(png)
    print(f'  ✓ Icône {size}x{size} créée : {filename}')

create_icon_png(192, 'public/icons/icon-192.png')
create_icon_png(512, 'public/icons/icon-512.png')
print('\nIcones générées avec succès !')
