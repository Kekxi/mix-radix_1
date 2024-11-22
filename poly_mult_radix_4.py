# DIT-NR-NTT & DIF-RN-INTT & precompute
import random
import math
# from scipy import poly1d

q = 3329
kesai = 7
inv_kesai = pow(kesai,2047) % q
kesai4_1 = pow(inv_kesai,1536) % q
print("kesai4_1 = ",kesai4_1)
print(pow(inv_kesai,1024) % q)
w = 49
inv_w = 1254
n_inv = 12277

w4 = [[],[],[],[]]
for j in range(4):
    for k in range(4):
        w4[j].insert(k,int(pow(w,k*256*j % 1024)%q))
        
print("w4_1 = ",w4[1][1])
        
inv_w4 = [[],[],[],[]]
for j in range(4):
    for k in range(4):
        inv_w4[j].insert(k,int(pow(inv_w,k*256*j % 1024)%q))

print("inv_w4_1 = ",inv_w4[1][1])

# print("ifftc = ",ifftc)
# ffta =  [2569, 2944, 1382, 2525, 2385, 1847, 2311, 404, 399, 2780, 2011, 975, 2842, 2143, 494, 2910, 1008, 312, 2505, 2404, 3159, 646, 629, 2999, 1533, 55, 570, 1111, 1544, 2400, 2046, 3235, 
#          2266, 2011, 1735, 1068, 2483, 2220, 2676, 2796, 2715, 1083, 2804, 2077, 2652, 2712, 2330, 201, 695, 3088, 2457, 2228, 318, 2434, 364, 2765, 1518, 78, 947, 2737, 839, 1157, 437, 2894,
#          3138, 1896, 1563, 1101, 865, 2813, 3146, 939, 628, 983, 768, 2709, 2966, 130, 2102, 639, 223, 1806, 2698, 829, 668, 2370, 1243, 119, 313, 3006, 1222, 379, 3087, 108, 2286, 1348,
#          1390,99, 1119, 1304, 2314, 782, 2090, 568, 335, 1586, 2291, 1287, 2403, 1510, 1665, 884, 3035, 3252, 1858, 2830, 127, 1408, 460, 2680, 526, 2929, 2582, 3154, 3092, 710, 736, 2660]

a0 =   [2569, 2944, 1382, 2525, 2385, 1847, 2311, 404, 399, 2780, 2011, 975, 2842, 2143, 494, 2910, 1008, 312, 2505, 2404, 3159, 646, 629, 2999, 1533, 55, 570, 1111, 1544, 2400, 2046, 3235,
        3138, 1896, 1563, 1101, 865, 2813, 3146, 939, 628, 983, 768, 2709, 2966, 130, 2102, 639, 223, 1806, 2698, 829, 668, 2370, 1243, 119, 313, 3006, 1222, 379, 3087, 108, 2286, 1348]
a1 =   [2266, 2011, 1735, 1068, 2483, 2220, 2676, 2796, 2715, 1083, 2804, 2077, 2652, 2712, 2330, 201, 695, 3088, 2457, 2228, 318, 2434, 364, 2765, 1518, 78, 947, 2737, 839, 1157, 437, 2894,
       1390, 99, 1119, 1304, 2314, 782, 2090, 568, 335, 1586, 2291, 1287, 2403, 1510, 1665, 884, 3035, 3252, 1858, 2830, 127, 1408, 460, 2680, 526, 2929, 2582, 3154, 3092, 710, 736, 2660]

# print(len(a0),len(a1))    

warray_1 = [1785, 2660, 2436, 798, 579, 2331, 1992, 2309, 1211, 1201, 2288, 2806, 2778, 3037, 2663, 1919, 600, 97, 1797, 2114, 254]   
warray_2 = [3747, 3430, 45, 3581, 3538, 2361, 1505, 2412, 2780, 1604, 2630, 3668, 560, 1480, 2455, 2132, 1102, 2337, 274, 408, 1149]   
warray_3 = [2623, 2185, 603, 2855, 3120, 4013, 683, 1038, 3773, 893, 692, 2329, 399, 3976, 116, 1808, 3105, 2239, 1139, 1538, 3441]   

warray_4 = [885, 2272, 2833, 1271, 772, 6, 408, 2131, 88, 1253, 2344, 714, 384, 2402, 1178, 1254, 541, 3032, 3044, 3071, 841]   
warray_5 = [2734, 604, 2212, 2756, 3430, 3117, 562, 2250, 2199, 89, 1044, 3178, 1204, 3521, 2253, 3709, 2638, 1087, 30, 2048, 663]   
warray_6 = [2214, 144, 4016, 3118, 142, 2419, 2089, 2414, 2729, 1101, 3748, 109, 319, 3451, 1163, 2206, 1807, 3717, 112, 2495, 2054]   

# print(len(warray_4),len(warray_5),len(warray_6))          
q=3329     
def DIT_NTT_0(a,omega):
    n = len(a)
    log_n = int(math.log(n,4))
    r = 0
    for i in range(log_n-1,-1,-1):
        J = int(pow(4,i))
        for k in range(int(n/(4*J))):
            wa1 = warray_1[r]
            wa2 = warray_2[r]
            wa3 = warray_3[r]
            r = r + 1
            for j in range(J):
                t0 = (a[k*4*J+j] + a[k*4*J+j+2*J]*wa2) % q
                t1 = (a[k*4*J+j] - a[k*4*J+j+2*J]*wa2) % q
                t2 = (a[k*4*J+j+J]*wa1 + a[k*4*J+j+3*J]*wa3) % q
                t3 = (a[k*4*J+j+J]*wa1 - a[k*4*J+j+3*J]*wa3) % q
                # print(k*4*J+j,k*4*J+j+1*J,k*4*J+j+2*J,k*4*J+j+3*J)
                # print(a[k*4*J+j],a[k*4*J+j+J],a[k*4*J+j+2*J],a[k*4*J+j+3*J],wa1,wa2,wa3)
                # print(a[k*4*J+j],a[k*4*J+j+2*J],wa2)
                # print(t0,t1)
                # print(a[k*4*J+j+J],a[k*4*J+j+3*J],wa1,wa3)
                # print(t2,t3)
                # print(a[k*4*J+j+J]*wa1,a[k*4*J+j+3*J]*wa3)
                # print(t0,t1,t2,t3)
                a[k*4*J+j] = (t0 + t2) % q
                a[k*4*J+j+J] = (t1 + t3 * w4[1][1]) % q
                a[k*4*J+j+2*J] = (t0 - t2) % q
                a[k*4*J+j+3*J] = (t1 - t3 * w4[1][1]) % q 
                # print(w4[1][1])
        print(a)        
    return a

# warray_1 =  [7143, 3542, 10643, 9744, 3195, 2319, 9088, 11334, 5086, 3091, 9326, 7969, 9238, 4846, 4805, 9154, 11227, 11112, 12149, 10654, 7678, 2401, 390, 7188, 8456, 1017, 27, 1632, 8526, 354, 5012, 9377, 2859, 1537, 9611, 4714, 5019, 2166, 12129, 12176, 12286, 3364, 9442, 4057, 2174, 3636, 10863, 5291, 1663, 7247, 5195, 4053, 7394, 1002, 7313, 5088, 8509, 11224, 1168, 11885, 11082, 9852, 9723, 6022, 6250, 493, 7952, 6845, 1378, 9042, 9919, 8311, 5332, 9890, 9289, 7098, 3016, 1630, 11136, 5407, 10040, 6730, 3985, 10111, 3531, 7, 3154, 845, 3285, 3120, 8348, 6203, 3536, 216, 767, 6763, 10076, 3229, 1282, 10583, 2021, 8820, 4693, 7846, 9996, 11009, 11385, 12265, 6742, 1802, 7878, 5103, 1223, 881, 5461, 1015, 2637, 3944, 2171, 5604, 11024, 9348, 3837, 6627, 3221, 9344, 9057, 2633, 4855, 4050, 11309, 844, 4590, 4684, 7302, 7154, 3670, 5618, 5043, 5789, 3090, 578, 7628, 11839, 9667, 3065, 6389, 6586, 7570, 343, 7078, 4538, 1208, 5412, 3515, 9011, 1218, 10584, 716, 11873, 2164, 10753, 1373, 2429, 717, 2065, 8755, 3495, 10533, 11014, 4860, 11113, 10844, 2275, 5063, 4267, 10771, 6302, 9520, 579, 6323, 8921, 8067, 4238, 11749, 3359, 3678, 5209, 10361, 3163, 1389, 6127, 4404, 1826, 1136, 4489, 3708, 8314, 1417, 6454, 7784, 4924, 1327, 1014, 3942, 3744, 5102, 2528, 6701, 2717, 5836, 3200, 2260, 4518, 2730, 1160, 10036, 7119, 189, 11424, 10526, 2478, 10506, 4194, 7724, 10759, 5832, 8420, 10555, 2873, 11169, 11498, 12268, 11259, 4649, 3821, 2929, 874, 2307, 170, 11641, 1573, 11787, 3793, 2602, 7014, 2035, 11038, 10407, 4834, 8176, 9461, 3840, 7519, 6616, 5287, 6883, 3451, 6508, 11048, 9646, 1849, 7988, 9021, 457, 7785, 3578, 530, 8823, 11410, 4218, 982, 8835, 10243, 3317, 9332, 139, 180, 10880, 7684, 204, 4739, 9261, 6771, 11925, 10821, 10945, 8882, 9806, 11053, 3121, 7043, 1057, 5598, 6565, 10397, 11260, 10975, 6599, 2894, 8342, 5959, 2442, 8330, 5115, 3343, 12269, 1522, 4608, 11883, 1403, 146, 6094, 3375, 7376, 8896, 3825, 12050, 4670, 994, 5464, 9342, 11667, 636, 5672, 4578, 10453, 11914, 10104, 506, 3276, 1392, 2212, 6085, 10058, 11251, 2800, 10347, 2776, 2575, 6811]
# warray_2 =  [10810, 10984, 5736, 722, 8155, 7468, 9664, 2639, 11340, 5728, 5023, 7698, 5828, 11726, 9283, 9314, 9545, 8961, 7311, 6512, 1351, 1260, 4632, 4388, 6534, 2013, 729, 9000, 3241, 2426, 1428, 334, 1696, 2881, 7197, 3284, 10200, 9447, 1022, 480, 9, 10616, 6958, 4278, 7300, 9821, 5791, 339, 544, 8112, 1381, 8705, 9764, 8595, 10530, 7110, 8582, 3637, 145, 3459, 6747, 3382, 9741, 11934, 8058, 9558, 7399, 8357, 6378, 11336, 827, 8541, 5767, 3949, 4452, 8993, 2396, 2476, 2197, 118, 7222, 7935, 2837, 130, 6915, 49, 5915, 1263, 1483, 1512, 10474, 350, 5383, 9789, 10706, 10800, 6347, 5369, 9087, 10232, 4493, 3030, 2361, 4115, 10446, 3963, 6142, 576, 9842, 2908, 3434, 218, 8760, 1954, 9407, 10238, 10484, 9551, 6554, 6421, 2655, 10314, 347, 8532, 2925, 9280, 174, 1693, 723, 8974, 1858, 11863, 4754, 3991, 9522, 8320, 156, 3772, 5908, 418, 11836, 2281, 10258, 5876, 5333, 5429, 7552, 7515, 1293, 7048, 8120, 9369, 9162, 5057, 4780, 4698, 8844, 6821, 8807, 1010, 787, 12097, 4912, 1321, 10240, 12231, 3532, 12048, 11286, 3477, 142, 6608, 11184, 1956, 11404, 7280, 6281, 9445, 11314, 3438, 4212, 677, 6234, 6415, 8953, 1579, 9784, 11858, 5906, 1323, 12237, 9523, 3174, 3957, 151, 9450, 10162, 9260, 4782, 6695, 5886, 11868, 3602, 8209, 6068, 8076, 2302, 504, 11684, 8689, 6077, 3263, 7665, 295, 5766, 6099, 652, 325, 11143, 10885, 11341, 8273, 8527, 4077, 9370, 5990, 8561, 1159, 8240, 8210, 922, 11231, 441, 4046, 9139, 709, 1319, 1958, 1112, 4322, 2078, 4240, 6224, 8719, 11454, 3329, 12121, 4298, 2692, 6167, 7105, 9734, 11089, 5961, 10327, 7183, 1594, 1360, 6170, 3956, 5297, 2459, 3656, 683, 12225, 9166, 9235, 10542, 6803, 10723, 9341, 5782, 9786, 7856, 3834, 6370, 7032, 7822, 6752, 7500, 4749, 6118, 1190, 8471, 9606, 4449, 12142, 6833, 8500, 3860, 7753, 5445, 11239, 654, 1702, 3565, 1987, 6136, 6874, 6427, 8646, 6760, 3199, 5206, 12233, 4948, 400, 6152, 10561, 5079, 2169, 9027, 11767, 11011, 1973, 9945, 6715, 7965, 8214, 4916, 5315, 8775, 5925, 11248, 11271, 5339, 3710, 5446, 6093, 10256, 3879, 8291, 1922, 468, 316, 8301, 11907, 10930, 973, 6854, 11035]
# warray_3 =  [4043, 10643, 8785, 5860, 2545, 3091, 9238, 11289, 2963, 9088, 11119, 10963, 955, 12149, 8034, 11563, 1635, 9154, 8736, 7443, 1062, 2166, 12286, 7370, 160, 7247, 7394, 2645, 7094, 10863, 4938, 10512, 6998, 4057, 7875, 8925, 10115, 1017, 8526, 7205, 12262, 390, 442, 3778, 5101, 9611, 242, 11744, 7575, 9377, 9808, 11935, 9430, 9890, 3016, 9153, 3000, 9919, 9603, 3510, 3978, 3985, 420, 476, 2178, 5407, 9405, 10659, 2249, 9852, 6250, 2987, 2566, 1168, 2143, 3248, 404, 5088, 10682, 11287, 3780, 6845, 11854, 11796, 10911, 343, 1208, 10381, 5211, 10753, 717, 8186, 10916, 716, 2450, 6873, 416, 9011, 11851, 6877, 11071, 8314, 7784, 3087, 10872, 2717, 2260, 10754, 6453, 5102, 4963, 6444, 9761, 1014, 3607, 7365, 8347, 3359, 10361, 1092, 8611, 8067, 4227, 12164, 8051, 1136, 2926, 9051, 7800, 6127, 10221, 9126, 7885, 2275, 10771, 5653, 7226, 4860, 5508, 11158, 1176, 3495, 3961, 10224, 1756, 579, 3114, 5987, 5966, 8820, 9996, 8871, 7596, 881, 2637, 10362, 6828, 7878, 1555, 9955, 7186, 12265, 9804, 1280, 5547, 3120, 3536, 5646, 3941, 3154, 1936, 7929, 11444, 1282, 4730, 9457, 1706, 6763, 8484, 12073, 2213, 5618, 3090, 3502, 7246, 7302, 3360, 3808, 5135, 6389, 1506, 11538, 5703, 11839, 11779, 11711, 2622, 9344, 4855, 1406, 3232, 3837, 11722, 4273, 5662, 5604, 8809, 8345, 1265, 844, 11607, 8239, 7699, 5598, 11260, 8665, 5724, 3343, 4608, 10138, 20, 2442, 10141, 4939, 3959, 2894, 9834, 1314, 3947, 4739, 11925, 1226, 3028, 10880, 4138, 5509, 4605, 3121, 9272, 9689, 5246, 8882, 9247, 1468, 2483, 506, 2212, 5784, 9013, 10453, 377, 11897, 375, 2776, 8881, 3511, 9714, 11251, 6197, 6204, 9489, 12050, 5464, 4554, 7619, 7376, 9998, 8054, 3393, 146, 1804, 406, 6195, 636, 10552, 2947, 6617, 7014, 10407, 6879, 10254, 3451, 9646, 4378, 5781, 6616, 944, 7624, 7002, 9461, 72, 7455, 8449, 11259, 2929, 1681, 7640, 11169, 2827, 6481, 791, 11787, 8443, 10388, 8496, 170, 4289, 11415, 648, 2478, 7724, 3019, 1783, 189, 2672, 2209, 865, 1160, 5411, 7771, 2253, 8420, 1350, 1530, 1734, 11410, 8835, 10013, 8071, 3578, 778, 1701, 11759, 9021, 7766, 10440, 11832, 9332, 9757, 2046, 12150]

# a = []
# for i in range(256):
#     a.append(i)

# ntt = DIT_NTT_0(a,7)


def DIT_NTT_1(a,omega):
    n = len(a)
    log_n = int(math.log(n,4))
    r = 0
    for i in range(log_n-1,-1,-1):
        J = int(pow(4,i))
        for k in range(int(n/(4*J))):
            wa1 = warray_4[r]
            wa2 = warray_5[r]
            wa3 = warray_6[r]
            r = r + 1
            for j in range(J):
                t0 = (a[k*4*J+j] + a[k*4*J+j+2*J]*wa2) % q
                t1 = (a[k*4*J+j] - a[k*4*J+j+2*J]*wa2) % q
                t2 = (a[k*4*J+j+J]*wa1 + a[k*4*J+j+3*J]*wa3) % q
                t3 = (a[k*4*J+j+J]*wa1 - a[k*4*J+j+3*J]*wa3) % q
                a[k*4*J+j] = (t0 + t2) % q
                a[k*4*J+j+J] = (t1 + t3 * w4[1][1]) % q
                a[k*4*J+j+2*J] = (t0 - t2) % q
                a[k*4*J+j+3*J] = (t1 - t3 * w4[1][1]) % q 
        print(a)        
    return a

# radix4_0 = DIT_NTT_0(a0,kesai)
# radix4_1 = DIT_NTT_1(a1,kesai)

# print(radix4_0)

# ffta =  [2569, 2944, 1382, 2525, 2385, 1847, 2311, 404, 399, 2780, 2011, 975, 2842, 2143, 494, 2910, 1008, 312, 2505, 2404, 3159, 646, 629, 2999, 1533, 55, 570, 1111, 1544, 2400, 2046, 3235, 
#          2266, 2011, 1735, 1068, 2483, 2220, 2676, 2796, 2715, 1083, 2804, 2077, 2652, 2712, 2330, 201, 695, 3088, 2457, 2228, 318, 2434, 364, 2765, 1518, 78, 947, 2737, 839, 1157, 437, 2894,
#          3138, 1896, 1563, 1101, 865, 2813, 3146, 939, 628, 983, 768, 2709, 2966, 130, 2102, 639, 223, 1806, 2698, 829, 668, 2370, 1243, 119, 313, 3006, 1222, 379, 3087, 108, 2286, 1348,
#          1390,99, 1119, 1304, 2314, 782, 2090, 568, 335, 1586, 2291, 1287, 2403, 1510, 1665, 884, 3035, 3252, 1858, 2830, 127, 1408, 460, 2680, 526, 2929, 2582, 3154, 3092, 710, 736, 2660]


# a0 =   [2569, 2944, 1382, 2525, 2385, 1847, 2311, 404, 399, 2780, 2011, 975, 2842, 2143, 494, 2910, 1008, 312, 2505, 2404, 3159, 646, 629, 2999, 1533, 55, 570, 1111, 1544, 2400, 2046, 3235,
#         3138, 1896, 1563, 1101, 865, 2813, 3146, 939, 628, 983, 768, 2709, 2966, 130, 2102, 639, 223, 1806, 2698, 829, 668, 2370, 1243, 119, 313, 3006, 1222, 379, 3087, 108, 2286, 1348]
# a1 =   [2266, 2011, 1735, 1068, 2483, 2220, 2676, 2796, 2715, 1083, 2804, 2077, 2652, 2712, 2330, 201, 695, 3088, 2457, 2228, 318, 2434, 364, 2765, 1518, 78, 947, 2737, 839, 1157, 437, 2894,
#        1390, 99, 1119, 1304, 2314, 782, 2090, 568, 335, 1586, 2291, 1287, 2403, 1510, 1665, 884, 3035, 3252, 1858, 2830, 127, 1408, 460, 2680, 526, 2929, 2582, 3154, 3092, 710, 736, 2660]

[3272, 789,  2210, 701,  1693, 1758, 1245, 2807, 1944, 849,  1706, 2603, 1614, 3115, 1120, 2758,   1586, 2100, 1306, 2299, 537,  1256, 3165, 2517, 1058, 1884, 1062, 2758, 2420, 2357, 2572, 1631, 
 1159, 344,  1187, 2163, 155,  2373, 701,  2977, 2455, 2183, 1952, 2341, 14,   1587, 3283, 1225,   2882, 871,  815,  1071, 2061, 2124, 804,  2998, 3173, 1784, 1684, 1055, 2449, 82,   1774, 942, 
 1982, 2222, 2254, 2652, 495,  1,    194,  690,  1209, 907,  1867, 351,  212,  3323, 2757, 1297,   30,   627,  2154, 2720, 523,  1395, 1850, 2942, 1873, 485,  1378, 1206, 2925, 498,  1493, 2104, 
 534,  1763, 3206, 1255, 539,  3256, 446,  1800, 2646, 523,  2519, 1934, 2870, 547,  1474, 3031,   1237, 1117, 2665, 1511, 153,  776,  1556, 2727, 1427, 179,  434,  3289, 2814, 1253, 152,  2785]

[298,  818,  1138, 1026,    1635, 1731, 1226, 2027,   1952, 1398, 3177, 314,   2808, 1086, 469,  1906,   2035, 2047, 1346, 1538,   1762, 415,  1692, 156,   3020, 2496, 512,  413,   597, 563,  966, 1435,
 290,  2544, 26,   792,     3141, 1299, 463,  1260,   2791, 2747, 1199, 2644,  1860, 2594, 2691, 566,    2251, 1778, 1714, 796,    3162, 3001, 464,  1671,  1052, 2707, 2660, 2247,  440, 3235, 1827, 984,
 2783, 2479, 1678, 200,     1919, 2345, 391,  3262,   2141, 772,  192,  2128,  2389, 1340, 263,  69,     865,  989,  2497, 2395,   2961, 684,  2981, 2048,  1116, 2220, 2554, 1157,  508, 1210, 2149, 165,
 3059, 644,  2669, 786,     1270, 2659, 2668, 2103,   1044, 642,  1119, 2193,  1737, 2032, 2743, 2479,   1193, 257,  2996, 1138,   314,  2713, 1452, 409,   1590, 1743, 2890, 405,   74,  2789, 2389, 131]   
           
           
[2548, 2020, 1388, 2875, 1470, 1454, 365,  469,  1375, 2055, 1181, 2948, 2190, 3151, 2540, 2355, 543,  1484, 2451, 264,  1864, 2770, 1447, 1252, 1768, 1492, 2732, 2311, 2080, 2495, 347,  735,               
 2367, 1681, 3061, 1732, 145,  2562, 298,  1301, 1610, 1633, 3294, 922,  2710, 1986, 1132, 2300, 2003, 2876, 260,  2201, 315,  452,  2554, 3128, 2360, 1393, 2247, 2917, 274,  779,  2844, 3132,             
 2007, 253,  2722, 2201, 3259, 51,   2251, 789,  2024, 1616, 2855, 1956, 1721, 490,  461,  2736, 2082, 2063, 404,  2348, 3226, 318,  3043, 342,  1140, 2172, 3062, 1689, 1928, 1477, 1097, 1348,                
 928 , 535,  632,  2099, 1666, 1839, 1433, 2521, 2799, 2531, 1234, 1679, 1282, 1813, 2094, 2886, 183,  2581, 345,  3288, 1643, 2450, 1471, 3192, 154,  2480, 3081, 2772, 1435, 338,  1073, 1739 ]        


