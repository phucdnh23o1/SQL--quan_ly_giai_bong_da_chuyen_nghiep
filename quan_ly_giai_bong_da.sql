

SET FOREIGN_KEY_CHECKS = 1;
-- 1. Bảng Mùa giải
CREATE TABLE mua_giai (
    ma_mua_giai VARCHAR(50) PRIMARY KEY,
    ten_mua_giai VARCHAR(255) NOT NULL,
    ngay_bat_dau DATE,
    ngay_ket_thuc DATE,
    trang_thai VARCHAR(50)
);

-- 2. Bảng Sân vận động
CREATE TABLE san_van_dong (
    ma_san VARCHAR(50) PRIMARY KEY,
    ten_san VARCHAR(255) NOT NULL,
    dia_chi_san VARCHAR(255),
    suc_chua INTEGER,
    loai_mat_co VARCHAR(100),
    nam_khanh_thanh INTEGER
);

-- 3. Bảng Câu lạc bộ
CREATE TABLE cau_lac_bo (
    ma_doi_bong VARCHAR(50) PRIMARY KEY,
    ten_clb VARCHAR(255) NOT NULL,
    dia_chi VARCHAR(255),
    ngan_sach REAL,
    nam_thanh_lap INTEGER,
    ma_san VARCHAR(50) UNIQUE, -- Quan hệ 1-1: so_huu
    FOREIGN KEY (ma_san) REFERENCES san_van_dong(ma_san)
);

-- 4. Bảng Huấn luyện viên
CREATE TABLE hlv (
    id_hlv VARCHAR(50) PRIMARY KEY,
    ten_hlv VARCHAR(255) NOT NULL,
    ngay_sinh DATE,
    quoc_tich VARCHAR(100),
    nam_kinh_nghiem INTEGER
);

-- 5. Bảng Hợp đồng HLV
CREATE TABLE hop_dong_hlv (
    ma_hd_hlv VARCHAR(50) PRIMARY KEY,
    vai_tro VARCHAR(100),
    ngay_bat_dau DATE,
    ngay_ket_thuc DATE,
    id_hlv VARCHAR(50),          -- Quan hệ: ky_hop_dong
    ma_doi_bong VARCHAR(50),     -- Quan hệ: bo_nhiem
    ma_mua_giai VARCHAR(50),     -- Quan hệ: ap_dung_mua
    FOREIGN KEY (id_hlv) REFERENCES hlv(id_hlv),
    FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong),
    FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai)
);

-- 6. Bảng Bảng xếp hạng
CREATE TABLE bang_xep_hang (
    ma_bxh VARCHAR(50) PRIMARY KEY,
    vong_dau INTEGER,
    thu_hang INTEGER,
    so_tran_thang INTEGER DEFAULT 0,
    so_tran_hoa INTEGER DEFAULT 0,
    so_tran_thua INTEGER DEFAULT 0,
    so_ban_thang INTEGER DEFAULT 0,
    so_ban_thua INTEGER DEFAULT 0,
    diem INTEGER DEFAULT 0,
    ma_mua_giai VARCHAR(50),     -- Quan hệ: co_bxh
    ma_doi_bong VARCHAR(50),     -- Quan hệ: xep_hang
    FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai),
    FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 7. Bảng Cầu thủ
CREATE TABLE cau_thu (
    ma_cau_thu VARCHAR(50) PRIMARY KEY,
    ho_ten VARCHAR(255) NOT NULL,
    ngay_sinh DATE,
    quoc_tich VARCHAR(100),
    chieu_cao REAL,
    can_nang REAL,
    vi_tri VARCHAR(50)
);

-- 8. Bảng Chuyển nhượng
CREATE TABLE chuyen_nhuong (
    ma_chuyen_nhuong VARCHAR(50) PRIMARY KEY,
    ngay_chuyen_nhuong DATE,
    gia_tri_chuyen_nhuong REAL,
    ma_cau_thu VARCHAR(50),      -- Quan hệ: thuc_hien
    doi_chuyen_di VARCHAR(50),   -- Quan hệ: doi_chuyen_di
    doi_chuyen_den VARCHAR(50),  -- Quan hệ: doi_chuyen_den
    FOREIGN KEY (ma_cau_thu) REFERENCES cau_thu(ma_cau_thu),
    FOREIGN KEY (doi_chuyen_di) REFERENCES cau_lac_bo(ma_doi_bong),
    FOREIGN KEY (doi_chuyen_den) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 9. Bảng Đăng ký cầu thủ (theo mùa giải & CLB)
CREATE TABLE dang_ky_cau_thu (
    ma_dang_ky VARCHAR(50) PRIMARY KEY,
    so_ao INTEGER,
    thoi_gian_dang_ky DATETIME,
    trang_thai VARCHAR(50),
    ma_cau_thu VARCHAR(50),      -- Quan hệ: duoc_dang_ky
    ma_doi_bong VARCHAR(50),     -- Quan hệ: dang_ky
    ma_mua_giai VARCHAR(50),     -- Quan hệ: co_dang_ky
    FOREIGN KEY (ma_cau_thu) REFERENCES cau_thu(ma_cau_thu),
    FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong),
    FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai)
);

-- 10. Bảng Trọng tài
CREATE TABLE trong_tai (
    ma_trong_tai VARCHAR(50) PRIMARY KEY,
    hoten VARCHAR(255) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(20),
    quoc_tich VARCHAR(100),
    chung_chi VARCHAR(100),
    kinh_nghiem INTEGER
);

-- 11. Bảng Trận đấu
CREATE TABLE tran_dau (
    id_tran VARCHAR(50) PRIMARY KEY,
    ten_tran VARCHAR(255),
    vong_dau INTEGER,
    thoi_gian_thi_dau DATETIME,
    ma_mua_giai VARCHAR(50),     -- Quan hệ: thuoc
    ma_san VARCHAR(50),          -- Quan hệ: to_chuc_tai
    doi_nha VARCHAR(50),         -- Quan hệ: doi_nha
    doi_khach VARCHAR(50),       -- Quan hệ: doi_khach
    FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai),
    FOREIGN KEY (ma_san) REFERENCES san_van_dong(ma_san),
    FOREIGN KEY (doi_nha) REFERENCES cau_lac_bo(ma_doi_bong),
    FOREIGN KEY (doi_khach) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 12. Bảng Thẻ phạt
CREATE TABLE the_phat (
    ma_the VARCHAR(50) PRIMARY KEY,
    loai_the VARCHAR(50),
    phut_nhan_the INTEGER,
    id_tran VARCHAR(50),         -- Quan hệ: co_the_phat
    ma_dang_ky VARCHAR(50),      -- Quan hệ: nhan_the
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    FOREIGN KEY (ma_dang_ky) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 13. Bảng Án phạt
CREATE TABLE an_phat (
    ma_an_phat VARCHAR(50) PRIMARY KEY,
    ly_do TEXT,
    trang_thai VARCHAR(50),
    ma_the VARCHAR(50) UNIQUE,   -- Quan hệ 1-1: bi_phat
    id_tran VARCHAR(50),         -- Quan hệ: treo_gio (trận bị treo giò/phát sinh án)
    FOREIGN KEY (ma_the) REFERENCES the_phat(ma_the),
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran)
);

-- 14. Bảng Chấn thương
CREATE TABLE chan_thuong (
    ma_chan_thuong VARCHAR(50) PRIMARY KEY,
    loai_chan_thuong VARCHAR(100),
    muc_do VARCHAR(50),
    phut_chan_thuong INTEGER,    -- Thuộc tính của quan hệ: xay_ra_trong
    id_tran VARCHAR(50),         -- Quan hệ: xay_ra_trong
    ma_dang_ky VARCHAR(50),      -- Quan hệ: mac_chan_thuong
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    FOREIGN KEY (ma_dang_ky) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 15. Bảng Bàn thắng
CREATE TABLE ban_thang (
    ma_ban_thang VARCHAR(50) PRIMARY KEY,
    loai_ban_thang VARCHAR(50),
    phut_ghi_ban INTEGER,
    id_tran VARCHAR(50),                 -- Quan hệ: co
    cau_thu_ghi_ban VARCHAR(50),         -- Quan hệ: ghi_ban
    cau_thu_kien_tao VARCHAR(50),        -- Quan hệ: kien_tao (có thể NULL)
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    FOREIGN KEY (cau_thu_ghi_ban) REFERENCES dang_ky_cau_thu(ma_dang_ky),
    FOREIGN KEY (cau_thu_kien_tao) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 16. Bảng Thay người
CREATE TABLE thay_nguoi (
    ma_thay_nguoi VARCHAR(50) PRIMARY KEY,
    phut_thay_nguoi INTEGER,
    id_tran VARCHAR(50),                 -- Quan hệ: co
    cau_thu_ra_san VARCHAR(50),          -- Quan hệ: cau_thu_ra_san
    cau_thu_vao_san VARCHAR(50),         -- Quan hệ: cau_thu_vao_san
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    FOREIGN KEY (cau_thu_ra_san) REFERENCES dang_ky_cau_thu(ma_dang_ky),
    FOREIGN KEY (cau_thu_vao_san) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- =====================================================================
-- CÁC BẢNG PHÁT SINH TỪ QUAN HỆ NHIỀU - NHIỀU (N - N)
-- =====================================================================

-- 17. Quan hệ N-N: mua_giai - cau_lac_bo (tham_gia)
CREATE TABLE mua_giai_clb (
    ma_mua_giai VARCHAR(50),
    ma_doi_bong VARCHAR(50),
    PRIMARY KEY (ma_mua_giai, ma_doi_bong),
    FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai),
    FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 18. Quan hệ N-N: trong_tai - tran_dau (chi_dao)
CREATE TABLE chi_dao_tran_dau (
    ma_trong_tai VARCHAR(50),
    id_tran VARCHAR(50),
    vai_tro_trong_tai VARCHAR(100),
    PRIMARY KEY (ma_trong_tai, id_tran),
    FOREIGN KEY (ma_trong_tai) REFERENCES trong_tai(ma_trong_tai),
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran)
);

-- 19. Quan hệ N-N: dang_ky_cau_thu - tran_dau (tham_gia)
CREATE TABLE tham_gia_tran_dau (
    ma_dang_ky VARCHAR(50),
    id_tran VARCHAR(50),
    da_chinh BOOLEAN DEFAULT 0, -- 1: Đá chính, 0: Dự bị
    so_phut_thi_dau INTEGER DEFAULT 0,
    PRIMARY KEY (ma_dang_ky, id_tran),
    FOREIGN KEY (ma_dang_ky) REFERENCES dang_ky_cau_thu(ma_dang_ky),
    FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran)
);


USE quan_ly_giai_bong_da;

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/01_mua_giai.csv'
INTO TABLE mua_giai FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/02_san_van_dong.csv'
INTO TABLE san_van_dong FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/03_cau_lac_bo.csv'
INTO TABLE cau_lac_bo FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/04_hlv.csv'
INTO TABLE hlv FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/05_hop_dong_hlv.csv'
INTO TABLE hop_dong_hlv FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/06_bang_xep_hang.csv'
INTO TABLE bang_xep_hang FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/07_cau_thu.csv'
INTO TABLE cau_thu FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/08_chuyen_nhuong.csv'
INTO TABLE chuyen_nhuong FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/09_dang_ky_cau_thu.csv'
INTO TABLE dang_ky_cau_thu FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/10_trong_tai.csv'
INTO TABLE trong_tai FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/11_tran_dau.csv'
INTO TABLE tran_dau FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/12_the_phat.csv'
INTO TABLE the_phat FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/13_an_phat.csv'
INTO TABLE an_phat FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/14_chan_thuong.csv'
INTO TABLE chan_thuong FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/15_ban_thang.csv'
INTO TABLE ban_thang FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(ma_ban_thang, loai_ban_thang, phut_ghi_ban, id_tran, cau_thu_ghi_ban, @v_kien_tao)
SET cau_thu_kien_tao = NULLIF(TRIM(REPLACE(@v_kien_tao, '\r', '')), '');

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/16_thay_nguoi.csv'
INTO TABLE thay_nguoi FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/17_mua_giai_clb.csv'
INTO TABLE mua_giai_clb FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/18_chi_dao_tran_dau.csv'
INTO TABLE chi_dao_tran_dau FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/vleague_3_mua_26_vong_toan_dien/19_tham_gia_tran_dau.csv'
INTO TABLE tham_gia_tran_dau FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 1;

USE quan_ly_giai_bong_da;

WITH ket_qua_tran AS (
    SELECT 
        td.id_tran,
        td.ma_mua_giai,
        td.vong_dau,
        td.doi_nha,
        td.doi_khach,
        SUM(CASE WHEN dk.ma_doi_bong = td.doi_nha THEN 1 ELSE 0 END) AS ban_nha,
        SUM(CASE WHEN dk.ma_doi_bong = td.doi_khach THEN 1 ELSE 0 END) AS ban_khach
    FROM tran_dau td
    LEFT JOIN ban_thang bt ON td.id_tran = bt.id_tran
    LEFT JOIN dang_ky_cau_thu dk ON bt.cau_thu_ghi_ban = dk.ma_dang_ky
    WHERE td.ma_mua_giai = 'VL2022'
      AND td.vong_dau <= 26
    GROUP BY td.id_tran, td.ma_mua_giai, td.vong_dau, td.doi_nha, td.doi_khach
),
thong_ke_tung_doi AS (
    -- Góc nhìn đội chủ nhà
    SELECT 
        doi_nha AS ma_doi_bong,
        CASE WHEN ban_nha > ban_khach THEN 3 WHEN ban_nha = ban_khach THEN 1 ELSE 0 END AS diem,
        CASE WHEN ban_nha > ban_khach THEN 1 ELSE 0 END AS thang,
        CASE WHEN ban_nha = ban_khach THEN 1 ELSE 0 END AS hoa,
        CASE WHEN ban_nha < ban_khach THEN 1 ELSE 0 END AS thua,
        ban_nha AS bt,
        ban_khach AS bb
    FROM ket_qua_tran
    UNION ALL
    -- Góc nhìn đội khách
    SELECT 
        doi_khach AS ma_doi_bong,
        CASE WHEN ban_khach > ban_nha THEN 3 WHEN ban_khach = ban_nha THEN 1 ELSE 0 END AS diem,
        CASE WHEN ban_khach > ban_nha THEN 1 ELSE 0 END AS thang,
        CASE WHEN ban_khach = ban_nha THEN 1 ELSE 0 END AS hoa,
        CASE WHEN ban_khach < ban_nha THEN 1 ELSE 0 END AS thua,
        ban_khach AS bt,
        ban_nha AS bb
    FROM ket_qua_tran
),
tong_hop_bxh AS (
    SELECT 
        clb.ma_doi_bong,
        clb.ten_clb,
        COUNT(*) AS SoTran,
        SUM(tk.thang) AS Thang,
        SUM(tk.hoa) AS Hoa,
        SUM(tk.thua) AS Thua,
        SUM(tk.bt) AS SoBanThang,
        SUM(tk.bb) AS SoBanThua,
        SUM(tk.bt - tk.bb) AS HieuSo,
        SUM(tk.diem) AS Diem
    FROM cau_lac_bo clb
    INNER JOIN thong_ke_tung_doi tk ON clb.ma_doi_bong = tk.ma_doi_bong
    GROUP BY clb.ma_doi_bong, clb.ten_clb
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY Diem DESC, HieuSo DESC, SoBanThang DESC) AS ThuHang,
    ma_doi_bong,
    ten_clb,
    SoTran,
    Thang,
    Hoa,
    Thua,
    SoBanThang,
    SoBanThua,
    HieuSo,
    Diem
FROM tong_hop_bxh
ORDER BY ThuHang ASC;