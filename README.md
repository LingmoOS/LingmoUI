# Lingmo UI

LingmoUI is a GUI library based on QQC (Qt Quick Controls) and Qt 6, every Lingmo application uses it.

## Features

* Light and Dark Mode
* Borderless window (Wayland & XCB Window move & resize)
* Blurred window
* Window shadow
* Desktop-level menu
* QQC Style
* ...

## Structures

- `Compatible`: This fold stores the old version of LingmoUI 1.0. (Will be removed in the future)

## Dependencies

(Outdated, needs update here)

```bash
sudo apt install libqt5x11extras5-dev libkf5windowsystem-dev qtbase5-private-dev libxcb1-dev libxcb-shape0-dev libxcb-icccm4-dev -y
```

## Build
Before build, make sure you have necessary Qt environment.

```bash
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
make
sudo make install
```

## Packaging

### Debian/Ubuntu

Install compile dependencies:

```bash
$ sudo apt install equivs devscripts --no-install-recommends
$ sudo mk-build-deps -i -t "apt --yes" -r
```

Start packing

```bash
$ dpkg-buildpackage -b -uc -us -tc
```

## License

LingmoUI is licensed under GPLv3.
