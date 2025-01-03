/*
CryptoJS v3.1.2
code.google.com/p/crypto-js
(c) 2009-2013 by Jeff Mott. All rights reserved.
code.google.com/p/crypto-js/wiki/License
*/
var CryptoJS = CryptoJS || function (a, j) {
    var c = {}, b = c.lib = {}, f = function () {
        }, l = b.Base = {
            extend: function (a) {
                f.prototype = this;
                var d = new f;
                a && d.mixIn(a);
                d.hasOwnProperty("init") || (d.init = function () {
                    d.$super.init.apply(this, arguments)
                });
                d.init.prototype = d;
                d.$super = this;
                return d
            },
            create: function () {
                var a = this.extend();
                a.init.apply(a, arguments);
                return a
            },
            init: function () {
            },
            mixIn: function (a) {
                for (var d in a) a.hasOwnProperty(d) && (this[d] = a[d]);
                a.hasOwnProperty("toString") && (this.toString = a.toString)
            },
            clone: function () {
                return this.init.prototype.extend(this)
            }
        },
        u = b.WordArray = l.extend({
            init: function (a, d) {
                a = this.words = a || [];
                this.sigBytes = d != j ? d : 4 * a.length
            },
            toString: function (a) {
                return (a || m).stringify(this)
            },
            concat: function (a) {
                var d = this.words,
                    M = a.words,
                    e = this.sigBytes;
                a = a.sigBytes;
                this.clamp();
                if (e % 4)
                    for (var b = 0; b < a; b++) d[e + b >>> 2] |= (M[b >>> 2] >>> 24 - 8 * (b % 4) & 255) << 24 - 8 * ((e + b) % 4);
                else if (65535 < M.length)
                    for (b = 0; b < a; b += 4) d[e + b >>> 2] = M[b >>> 2];
                else d.push.apply(d, M);
                this.sigBytes += a;
                return this
            },
            clamp: function () {
                var D = this.words,
                    d = this.sigBytes;
                D[d >>> 2] &= 4294967295 <<
                    32 - 8 * (d % 4);
                D.length = a.ceil(d / 4)
            },
            clone: function () {
                var a = l.clone.call(this);
                a.words = this.words.slice(0);
                return a
            },
            random: function (D) {
                for (var d = [], b = 0; b < D; b += 4) d.push(4294967296 * a.random() | 0);
                return new u.init(d, D)
            }
        }),
        k = c.enc = {}, m = k.Hex = {
            stringify: function (a) {
                var d = a.words;
                a = a.sigBytes;
                for (var b = [], e = 0; e < a; e++) {
                    var c = d[e >>> 2] >>> 24 - 8 * (e % 4) & 255;
                    b.push((c >>> 4).toString(16));
                    b.push((c & 15).toString(16))
                }
                return b.join("")
            },
            parse: function (a) {
                for (var d = a.length, b = [], e = 0; e < d; e += 2) b[e >>> 3] |= parseInt(a.substr(e,
                    2), 16) << 24 - 4 * (e % 8);
                return new u.init(b, d / 2)
            }
        }, y = k.Latin1 = {
            stringify: function (a) {
                var b = a.words;
                a = a.sigBytes;
                for (var c = [], e = 0; e < a; e++) c.push(String.fromCharCode(b[e >>> 2] >>> 24 - 8 * (e % 4) & 255));
                return c.join("")
            },
            parse: function (a) {
                for (var b = a.length, c = [], e = 0; e < b; e++) c[e >>> 2] |= (a.charCodeAt(e) & 255) << 24 - 8 * (e % 4);
                return new u.init(c, b)
            }
        }, z = k.Utf8 = {
            stringify: function (a) {
                try {
                    return decodeURIComponent(escape(y.stringify(a)))
                } catch (b) {
                    throw Error("Malformed UTF-8 data");
                }
            },
            parse: function (a) {
                return y.parse(unescape(encodeURIComponent(a)))
            }
        },
        x = b.BufferedBlockAlgorithm = l.extend({
            reset: function () {
                this._data = new u.init;
                this._nDataBytes = 0
            },
            _append: function (a) {
                "string" == typeof a && (a = z.parse(a));
                this._data.concat(a);
                this._nDataBytes += a.sigBytes
            },
            _process: function (b) {
                var d = this._data,
                    c = d.words,
                    e = d.sigBytes,
                    l = this.blockSize,
                    k = e / (4 * l),
                    k = b ? a.ceil(k) : a.max((k | 0) - this._minBufferSize, 0);
                b = k * l;
                e = a.min(4 * b, e);
                if (b) {
                    for (var x = 0; x < b; x += l) this._doProcessBlock(c, x);
                    x = c.splice(0, b);
                    d.sigBytes -= e
                }
                return new u.init(x, e)
            },
            clone: function () {
                var a = l.clone.call(this);
                a._data = this._data.clone();
                return a
            },
            _minBufferSize: 0
        });
    b.Hasher = x.extend({
        cfg: l.extend(),
        init: function (a) {
            this.cfg = this.cfg.extend(a);
            this.reset()
        },
        reset: function () {
            x.reset.call(this);
            this._doReset()
        },
        update: function (a) {
            this._append(a);
            this._process();
            return this
        },
        finalize: function (a) {
            a && this._append(a);
            return this._doFinalize()
        },
        blockSize: 16,
        _createHelper: function (a) {
            return function (b, c) {
                return (new a.init(c)).finalize(b)
            }
        },
        _createHmacHelper: function (a) {
            return function (b, c) {
                return (new ja.HMAC.init(a,
                    c)).finalize(b)
            }
        }
    });
    var ja = c.algo = {};
    return c
}(Math);
(function (a) {
    var j = CryptoJS,
        c = j.lib,
        b = c.Base,
        f = c.WordArray,
        j = j.x64 = {};
    j.Word = b.extend({
        init: function (a, b) {
            this.high = a;
            this.low = b
        }
    });
    j.WordArray = b.extend({
        init: function (b, c) {
            b = this.words = b || [];
            this.sigBytes = c != a ? c : 8 * b.length
        },
        toX32: function () {
            for (var a = this.words, b = a.length, c = [], m = 0; m < b; m++) {
                var y = a[m];
                c.push(y.high);
                c.push(y.low)
            }
            return f.create(c, this.sigBytes)
        },
        clone: function () {
            for (var a = b.clone.call(this), c = a.words = this.words.slice(0), k = c.length, f = 0; f < k; f++) c[f] = c[f].clone();
            return a
        }
    })
})();
(function () {
    function a() {
        return f.create.apply(f, arguments)
    }

    for (var j = CryptoJS, c = j.lib.Hasher, b = j.x64, f = b.Word, l = b.WordArray, b = j.algo, u = [a(1116352408, 3609767458), a(1899447441, 602891725), a(3049323471, 3964484399), a(3921009573, 2173295548), a(961987163, 4081628472), a(1508970993, 3053834265), a(2453635748, 2937671579), a(2870763221, 3664609560), a(3624381080, 2734883394), a(310598401, 1164996542), a(607225278, 1323610764), a(1426881987, 3590304994), a(1925078388, 4068182383), a(2162078206, 991336113), a(2614888103, 633803317),
        a(3248222580, 3479774868), a(3835390401, 2666613458), a(4022224774, 944711139), a(264347078, 2341262773), a(604807628, 2007800933), a(770255983, 1495990901), a(1249150122, 1856431235), a(1555081692, 3175218132), a(1996064986, 2198950837), a(2554220882, 3999719339), a(2821834349, 766784016), a(2952996808, 2566594879), a(3210313671, 3203337956), a(3336571891, 1034457026), a(3584528711, 2466948901), a(113926993, 3758326383), a(338241895, 168717936), a(666307205, 1188179964), a(773529912, 1546045734), a(1294757372, 1522805485), a(1396182291,
            2643833823), a(1695183700, 2343527390), a(1986661051, 1014477480), a(2177026350, 1206759142), a(2456956037, 344077627), a(2730485921, 1290863460), a(2820302411, 3158454273), a(3259730800, 3505952657), a(3345764771, 106217008), a(3516065817, 3606008344), a(3600352804, 1432725776), a(4094571909, 1467031594), a(275423344, 851169720), a(430227734, 3100823752), a(506948616, 1363258195), a(659060556, 3750685593), a(883997877, 3785050280), a(958139571, 3318307427), a(1322822218, 3812723403), a(1537002063, 2003034995), a(1747873779, 3602036899),
        a(1955562222, 1575990012), a(2024104815, 1125592928), a(2227730452, 2716904306), a(2361852424, 442776044), a(2428436474, 593698344), a(2756734187, 3733110249), a(3204031479, 2999351573), a(3329325298, 3815920427), a(3391569614, 3928383900), a(3515267271, 566280711), a(3940187606, 3454069534), a(4118630271, 4000239992), a(116418474, 1914138554), a(174292421, 2731055270), a(289380356, 3203993006), a(460393269, 320620315), a(685471733, 587496836), a(852142971, 1086792851), a(1017036298, 365543100), a(1126000580, 2618297676), a(1288033470,
            3409855158), a(1501505948, 4234509866), a(1607167915, 987167468), a(1816402316, 1246189591)
    ], k = [], m = 0; 80 > m; m++) k[m] = a();
    b = b.SHA512 = c.extend({
        _doReset: function () {
            this._hash = new l.init([new f.init(1779033703, 4089235720), new f.init(3144134277, 2227873595), new f.init(1013904242, 4271175723), new f.init(2773480762, 1595750129), new f.init(1359893119, 2917565137), new f.init(2600822924, 725511199), new f.init(528734635, 4215389547), new f.init(1541459225, 327033209)])
        },
        _doProcessBlock: function (a, b) {
            for (var c = this._hash.words,
                     f = c[0], j = c[1], d = c[2], l = c[3], e = c[4], m = c[5], N = c[6], c = c[7], aa = f.high, O = f.low, ba = j.high, P = j.low, ca = d.high, Q = d.low, da = l.high, R = l.low, ea = e.high, S = e.low, fa = m.high, T = m.low, ga = N.high, U = N.low, ha = c.high, V = c.low, r = aa, n = O, G = ba, E = P, H = ca, F = Q, Y = da, I = R, s = ea, p = S, W = fa, J = T, X = ga, K = U, Z = ha, L = V, t = 0; 80 > t; t++) {
                var A = k[t];
                if (16 > t) var q = A.high = a[b + 2 * t] | 0,
                    g = A.low = a[b + 2 * t + 1] | 0;
                else {
                    var q = k[t - 15],
                        g = q.high,
                        v = q.low,
                        q = (g >>> 1 | v << 31) ^ (g >>> 8 | v << 24) ^ g >>> 7,
                        v = (v >>> 1 | g << 31) ^ (v >>> 8 | g << 24) ^ (v >>> 7 | g << 25),
                        C = k[t - 2],
                        g = C.high,
                        h = C.low,
                        C = (g >>> 19 |
                            h << 13) ^ (g << 3 | h >>> 29) ^ g >>> 6,
                        h = (h >>> 19 | g << 13) ^ (h << 3 | g >>> 29) ^ (h >>> 6 | g << 26),
                        g = k[t - 7],
                        $ = g.high,
                        B = k[t - 16],
                        w = B.high,
                        B = B.low,
                        g = v + g.low,
                        q = q + $ + (g >>> 0 < v >>> 0 ? 1 : 0),
                        g = g + h,
                        q = q + C + (g >>> 0 < h >>> 0 ? 1 : 0),
                        g = g + B,
                        q = q + w + (g >>> 0 < B >>> 0 ? 1 : 0);
                    A.high = q;
                    A.low = g
                }
                var $ = s & W ^ ~s & X,
                    B = p & J ^ ~p & K,
                    A = r & G ^ r & H ^ G & H,
                    ka = n & E ^ n & F ^ E & F,
                    v = (r >>> 28 | n << 4) ^ (r << 30 | n >>> 2) ^ (r << 25 | n >>> 7),
                    C = (n >>> 28 | r << 4) ^ (n << 30 | r >>> 2) ^ (n << 25 | r >>> 7),
                    h = u[t],
                    la = h.high,
                    ia = h.low,
                    h = L + ((p >>> 14 | s << 18) ^ (p >>> 18 | s << 14) ^ (p << 23 | s >>> 9)),
                    w = Z + ((s >>> 14 | p << 18) ^ (s >>> 18 | p << 14) ^ (s << 23 | p >>> 9)) + (h >>>
                    0 < L >>> 0 ? 1 : 0),
                    h = h + B,
                    w = w + $ + (h >>> 0 < B >>> 0 ? 1 : 0),
                    h = h + ia,
                    w = w + la + (h >>> 0 < ia >>> 0 ? 1 : 0),
                    h = h + g,
                    w = w + q + (h >>> 0 < g >>> 0 ? 1 : 0),
                    g = C + ka,
                    A = v + A + (g >>> 0 < C >>> 0 ? 1 : 0),
                    Z = X,
                    L = K,
                    X = W,
                    K = J,
                    W = s,
                    J = p,
                    p = I + h | 0,
                    s = Y + w + (p >>> 0 < I >>> 0 ? 1 : 0) | 0,
                    Y = H,
                    I = F,
                    H = G,
                    F = E,
                    G = r,
                    E = n,
                    n = h + g | 0,
                    r = w + A + (n >>> 0 < h >>> 0 ? 1 : 0) | 0
            }
            O = f.low = O + n;
            f.high = aa + r + (O >>> 0 < n >>> 0 ? 1 : 0);
            P = j.low = P + E;
            j.high = ba + G + (P >>> 0 < E >>> 0 ? 1 : 0);
            Q = d.low = Q + F;
            d.high = ca + H + (Q >>> 0 < F >>> 0 ? 1 : 0);
            R = l.low = R + I;
            l.high = da + Y + (R >>> 0 < I >>> 0 ? 1 : 0);
            S = e.low = S + p;
            e.high = ea + s + (S >>> 0 < p >>> 0 ? 1 : 0);
            T = m.low = T + J;
            m.high = fa + W + (T >>> 0 < J >>> 0 ? 1 :
                0);
            U = N.low = U + K;
            N.high = ga + X + (U >>> 0 < K >>> 0 ? 1 : 0);
            V = c.low = V + L;
            c.high = ha + Z + (V >>> 0 < L >>> 0 ? 1 : 0)
        },
        _doFinalize: function () {
            var a = this._data,
                b = a.words,
                c = 8 * this._nDataBytes,
                f = 8 * a.sigBytes;
            b[f >>> 5] |= 128 << 24 - f % 32;
            b[(f + 128 >>> 10 << 5) + 30] = Math.floor(c / 4294967296);
            b[(f + 128 >>> 10 << 5) + 31] = c;
            a.sigBytes = 4 * b.length;
            this._process();
            return this._hash.toX32()
        },
        clone: function () {
            var a = c.clone.call(this);
            a._hash = this._hash.clone();
            return a
        },
        blockSize: 32
    });
    j.SHA512 = c._createHelper(b);
    j.HmacSHA512 = c._createHmacHelper(b)
})();
(function () {
    var a = CryptoJS,
        j = a.enc.Utf8;
    a.algo.HMAC = a.lib.Base.extend({
        init: function (a, b) {
            a = this._hasher = new a.init;
            "string" == typeof b && (b = j.parse(b));
            var f = a.blockSize,
                l = 4 * f;
            b.sigBytes > l && (b = a.finalize(b));
            b.clamp();
            for (var u = this._oKey = b.clone(), k = this._iKey = b.clone(), m = u.words, y = k.words, z = 0; z < f; z++) m[z] ^= 1549556828, y[z] ^= 909522486;
            u.sigBytes = k.sigBytes = l;
            this.reset()
        },
        reset: function () {
            var a = this._hasher;
            a.reset();
            a.update(this._iKey)
        },
        update: function (a) {
            this._hasher.update(a);
            return this
        },
        finalize: function (a) {
            var b =
                this._hasher;
            a = b.finalize(a);
            b.reset();
            return b.finalize(this._oKey.clone().concat(a))
        }
    })
})();