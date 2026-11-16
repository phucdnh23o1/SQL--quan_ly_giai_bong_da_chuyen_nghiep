DROP DATABASE IF EXISTS quan_ly_giai_bong_da;
CREATE DATABASE quan_ly_giai_bong_da
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE quan_ly_giai_bong_da;

-- 1. Mùa giải
CREATE TABLE mua_giai (
    ma_mua_giai VARCHAR(20) PRIMARY KEY,
    ten_mua_giai VARCHAR(255) NOT NULL,
    ngay_bat_dau DATE NOT NULL,
    ngay_ket_thuc DATE NOT NULL,
    trang_thai VARCHAR(50) NOT NULL,
    CONSTRAINT chk_ngay_mua_giai CHECK (ngay_ket_thuc >= ngay_bat_dau)
);

-- 2. Sân vận động
CREATE TABLE san_van_dong (
    ma_san VARCHAR(20) PRIMARY KEY,
    ten_san VARCHAR(255) NOT NULL,
    dia_chi_san VARCHAR(255) NOT NULL,
    suc_chua INT NOT NULL,
    loai_mat_co VARCHAR(100),
    nam_khanh_thanh INT,
    CONSTRAINT chk_suc_chua CHECK (suc_chua > 0)
);

-- 3. Câu lạc bộ
CREATE TABLE cau_lac_bo (
    ma_doi_bong VARCHAR(20) PRIMARY KEY,
    ten_clb VARCHAR(255) NOT NULL,
    dia_chi VARCHAR(255),
    ngan_sach DECIMAL(18, 2),
    nam_thanh_lap INT,
    ma_san VARCHAR(20) NOT NULL,
    CONSTRAINT fk_clb_san FOREIGN KEY (ma_san) REFERENCES san_van_dong(ma_san)
);

-- 4. Huấn luyện viên
CREATE TABLE hlv (
    id_hlv VARCHAR(20) PRIMARY KEY,
    ten_hlv VARCHAR(255) NOT NULL,
    ngay_sinh DATE,
    quoc_tich VARCHAR(100) NOT NULL,
    nam_kinh_nghiem INT DEFAULT 0
);

-- 5. Hợp đồng HLV
CREATE TABLE hop_dong_hlv (
    ma_hd_hlv VARCHAR(20) PRIMARY KEY,
    vai_tro VARCHAR(100) NOT NULL,
    ngay_bat_dau DATE NOT NULL,
    ngay_ket_thuc DATE NOT NULL,
    id_hlv VARCHAR(20) NOT NULL,
    ma_doi_bong VARCHAR(20) NOT NULL,
    ma_mua_giai VARCHAR(20) NOT NULL,
    CONSTRAINT fk_hdhlv_hlv FOREIGN KEY (id_hlv) REFERENCES hlv(id_hlv),
    CONSTRAINT fk_hdhlv_clb FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong),
    CONSTRAINT fk_hdhlv_mg FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai)
);

-- 6. Bảng xếp hạng
CREATE TABLE bang_xep_hang (
    ma_bxh VARCHAR(30) PRIMARY KEY,
    vong_dau INT NOT NULL,
    thu_hang INT NOT NULL,
    so_tran_thang INT DEFAULT 0,
    so_tran_hoa INT DEFAULT 0,
    so_tran_thua INT DEFAULT 0,
    so_ban_thang INT DEFAULT 0,
    so_ban_thua INT DEFAULT 0,
    diem INT DEFAULT 0,
    ma_mua_giai VARCHAR(20) NOT NULL,
    ma_doi_bong VARCHAR(20) NOT NULL,
    CONSTRAINT fk_bxh_mg FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai),
    CONSTRAINT fk_bxh_clb FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 7. Cầu thủ
CREATE TABLE cau_thu (
    ma_cau_thu VARCHAR(20) PRIMARY KEY,
    ho_ten VARCHAR(255) NOT NULL,
    ngay_sinh DATE NOT NULL,
    quoc_tich VARCHAR(100) NOT NULL,
    chieu_cao DECIMAL(4, 2),
    can_nang DECIMAL(5, 2),
    vi_tri VARCHAR(50) NOT NULL
);

-- 8. Chuyển nhượng
CREATE TABLE chuyen_nhuong (
    ma_chuyen_nhuong VARCHAR(20) PRIMARY KEY,
    ngay_chuyen_nhuong DATE NOT NULL,
    gia_tri_chuyen_nhuong DECIMAL(18, 2) DEFAULT 0,
    ma_cau_thu VARCHAR(20) NOT NULL,
    doi_chuyen_di VARCHAR(20) NOT NULL,
    doi_chuyen_den VARCHAR(20) NOT NULL,
    CONSTRAINT fk_cn_ct FOREIGN KEY (ma_cau_thu) REFERENCES cau_thu(ma_cau_thu),
    CONSTRAINT fk_cn_di FOREIGN KEY (doi_chuyen_di) REFERENCES cau_lac_bo(ma_doi_bong),
    CONSTRAINT fk_cn_den FOREIGN KEY (doi_chuyen_den) REFERENCES cau_lac_bo(ma_doi_bong),
    CONSTRAINT chk_cn_doi CHECK (doi_chuyen_di <> doi_chuyen_den)
);

-- 9. Đăng ký cầu thủ (Có CHECK so_ao [1, 99] và UNIQUE (ma_mua_giai, ma_doi_bong, so_ao))
CREATE TABLE dang_ky_cau_thu (
    ma_dang_ky VARCHAR(20) PRIMARY KEY,
    so_ao INT NOT NULL,
    thoi_gian_dang_ky DATETIME NOT NULL,
    trang_thai VARCHAR(50) NOT NULL,
    ma_cau_thu VARCHAR(20) NOT NULL,
    ma_doi_bong VARCHAR(20) NOT NULL,
    ma_mua_giai VARCHAR(20) NOT NULL,
    CONSTRAINT chk_so_ao CHECK (so_ao BETWEEN 1 AND 99),
    CONSTRAINT uq_doi_bong_so_ao UNIQUE (ma_mua_giai, ma_doi_bong, so_ao),
    CONSTRAINT fk_dk_ct FOREIGN KEY (ma_cau_thu) REFERENCES cau_thu(ma_cau_thu),
    CONSTRAINT fk_dk_clb FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong),
    CONSTRAINT fk_dk_mg FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai)
);

-- 10. Trọng tài
CREATE TABLE trong_tai (
    ma_trong_tai VARCHAR(20) PRIMARY KEY,
    hoten VARCHAR(255) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(20) NOT NULL,
    quoc_tich VARCHAR(100) NOT NULL,
    chung_chi VARCHAR(100),
    kinh_nghiem INT DEFAULT 0
);

-- 11. Trận đấu (Có CHECK doi_nha <> doi_khach)
CREATE TABLE tran_dau (
    id_tran VARCHAR(20) PRIMARY KEY,
    ten_tran VARCHAR(255) NOT NULL,
    vong_dau INT NOT NULL,
    thoi_gian_thi_dau DATETIME NOT NULL,
    ma_mua_giai VARCHAR(20) NOT NULL,
    ma_san VARCHAR(20) NOT NULL,
    doi_nha VARCHAR(20) NOT NULL,
    doi_khach VARCHAR(20) NOT NULL,
    CONSTRAINT chk_doi_nha_khach CHECK (doi_nha <> doi_khach),
    CONSTRAINT fk_td_mg FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai),
    CONSTRAINT fk_td_san FOREIGN KEY (ma_san) REFERENCES san_van_dong(ma_san),
    CONSTRAINT fk_td_nha FOREIGN KEY (doi_nha) REFERENCES cau_lac_bo(ma_doi_bong),
    CONSTRAINT fk_td_khach FOREIGN KEY (doi_khach) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 12. Thẻ phạt
CREATE TABLE the_phat (
    ma_the VARCHAR(20) PRIMARY KEY,
    loai_the VARCHAR(50) NOT NULL,
    phut_nhan_the INT NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    ma_dang_ky VARCHAR(20) NOT NULL,
    CONSTRAINT chk_phut_the CHECK (phut_nhan_the BETWEEN 1 AND 120),
    CONSTRAINT fk_tp_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    CONSTRAINT fk_tp_dk FOREIGN KEY (ma_dang_ky) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 13. Án phạt
CREATE TABLE an_phat (
    ma_an_phat VARCHAR(20) PRIMARY KEY,
    ly_do VARCHAR(255) NOT NULL,
    trang_thai VARCHAR(50) NOT NULL,
    ma_the VARCHAR(20) NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    CONSTRAINT fk_ap_the FOREIGN KEY (ma_the) REFERENCES the_phat(ma_the),
    CONSTRAINT fk_ap_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran)
);

-- 14. Chấn thương
CREATE TABLE chan_thuong (
    ma_chan_thuong VARCHAR(20) PRIMARY KEY,
    loai_chan_thuong VARCHAR(255) NOT NULL,
    muc_do VARCHAR(50) NOT NULL,
    phut_chan_thuong INT NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    ma_dang_ky VARCHAR(20) NOT NULL,
    CONSTRAINT chk_phut_ct CHECK (phut_chan_thuong BETWEEN 1 AND 120),
    CONSTRAINT fk_cth_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    CONSTRAINT fk_cth_dk FOREIGN KEY (ma_dang_ky) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 15. Bàn thắng (Có CHECK phut_ghi_ban [1, 120])
CREATE TABLE ban_thang (
    ma_ban_thang VARCHAR(20) PRIMARY KEY,
    loai_ban_thang VARCHAR(50) NOT NULL,
    phut_ghi_ban INT NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    cau_thu_ghi_ban VARCHAR(20) NOT NULL,
    cau_thu_kien_tao VARCHAR(20) NULL,
    CONSTRAINT chk_phut_ghi_ban CHECK (phut_ghi_ban BETWEEN 1 AND 120),
    CONSTRAINT fk_bt_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    CONSTRAINT fk_bt_gb FOREIGN KEY (cau_thu_ghi_ban) REFERENCES dang_ky_cau_thu(ma_dang_ky),
    CONSTRAINT fk_bt_kt FOREIGN KEY (cau_thu_kien_tao) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 16. Thay người
CREATE TABLE thay_nguoi (
    ma_thay_nguoi VARCHAR(20) PRIMARY KEY,
    phut_thay_nguoi INT NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    cau_thu_ra_san VARCHAR(20) NOT NULL,
    cau_thu_vao_san VARCHAR(20) NOT NULL,
    CONSTRAINT chk_phut_tn CHECK (phut_thay_nguoi BETWEEN 1 AND 120),
    CONSTRAINT chk_ra_vao_khac_nhau CHECK (cau_thu_ra_san <> cau_thu_vao_san),
    CONSTRAINT fk_tn_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran),
    CONSTRAINT fk_tn_ra FOREIGN KEY (cau_thu_ra_san) REFERENCES dang_ky_cau_thu(ma_dang_ky),
    CONSTRAINT fk_tn_vao FOREIGN KEY (cau_thu_vao_san) REFERENCES dang_ky_cau_thu(ma_dang_ky)
);

-- 17. Mùa giải - Câu lạc bộ
CREATE TABLE mua_giai_clb (
    ma_mua_giai VARCHAR(20) NOT NULL,
    ma_doi_bong VARCHAR(20) NOT NULL,
    PRIMARY KEY (ma_mua_giai, ma_doi_bong),
    CONSTRAINT fk_mgclb_mg FOREIGN KEY (ma_mua_giai) REFERENCES mua_giai(ma_mua_giai),
    CONSTRAINT fk_mgclb_clb FOREIGN KEY (ma_doi_bong) REFERENCES cau_lac_bo(ma_doi_bong)
);

-- 18. Chỉ đạo trận đấu (Tổ trọng tài)
CREATE TABLE chi_dao_tran_dau (
    ma_trong_tai VARCHAR(20) NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    vai_tro_trong_tai VARCHAR(100) NOT NULL,
    PRIMARY KEY (ma_trong_tai, id_tran),
    CONSTRAINT fk_cdtd_tt FOREIGN KEY (ma_trong_tai) REFERENCES trong_tai(ma_trong_tai),
    CONSTRAINT fk_cdtd_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran)
);

-- 19. Tham gia trận đấu
CREATE TABLE tham_gia_tran_dau (
    ma_dang_ky VARCHAR(20) NOT NULL,
    id_tran VARCHAR(20) NOT NULL,
    da_chinh TINYINT(1) NOT NULL DEFAULT 0,
    so_phut_thi_dau INT NOT NULL DEFAULT 0,
    PRIMARY KEY (ma_dang_ky, id_tran),
    CONSTRAINT chk_so_phut_td CHECK (so_phut_thi_dau BETWEEN 0 AND 120),
    CONSTRAINT fk_tgtd_dk FOREIGN KEY (ma_dang_ky) REFERENCES dang_ky_cau_thu(ma_dang_ky),
    CONSTRAINT fk_tgtd_tran FOREIGN KEY (id_tran) REFERENCES tran_dau(id_tran)
);
USE quan_ly_giai_bong_da;

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/01_mua_giai.csv'
INTO TABLE mua_giai FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/02_san_van_dong.csv'
INTO TABLE san_van_dong FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/03_cau_lac_bo.csv'
INTO TABLE cau_lac_bo FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/04_hlv.csv'
INTO TABLE hlv FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/05_hop_dong_hlv.csv'
INTO TABLE hop_dong_hlv FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/06_bang_xep_hang.csv'
INTO TABLE bang_xep_hang FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/07_cau_thu.csv'
INTO TABLE cau_thu FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/08_chuyen_nhuong.csv'
INTO TABLE chuyen_nhuong FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/09_dang_ky_cau_thu.csv'
INTO TABLE dang_ky_cau_thu FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/vleague_csv_3seasons_fixed_v3_10_trong_tai.csv'
INTO TABLE trong_tai FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/11_tran_dau.csv'
INTO TABLE tran_dau FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/12_the_phat.csv'
INTO TABLE the_phat FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/13_an_phat.csv'
INTO TABLE an_phat FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/14_chan_thuong.csv'
INTO TABLE chan_thuong FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/15_ban_thang.csv'
INTO TABLE ban_thang FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(ma_ban_thang, loai_ban_thang, phut_ghi_ban, id_tran, cau_thu_ghi_ban, @v_kien_tao)
SET cau_thu_kien_tao = NULLIF(TRIM(REPLACE(@v_kien_tao, '\r', '')), '');

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/16_thay_nguoi.csv'
INTO TABLE thay_nguoi FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/17_mua_giai_clb.csv'
INTO TABLE mua_giai_clb FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/18_chi_dao_tran_dau.csv'
INTO TABLE chi_dao_tran_dau FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/PROJECT/20. Quản lý Giải đấu Bóng đá Chuyên nghiệp/vleague_3_mua_26_vong_toan_dien/19_tham_gia_tran_dau.csv'
INTO TABLE tham_gia_tran_dau FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

CREATE TRIGGER trg_auto_an_phat_sau_the
AFTER INSERT ON the_phat
FOR EACH ROW
BEGIN
    DECLARE v_so_the_vang INT DEFAULT 0;
    DECLARE v_vong_hien_tai INT;
    DECLARE v_ma_mua_giai VARCHAR(20);
    DECLARE v_ma_doi_bong VARCHAR(20);
    DECLARE v_id_tran_ke_tiep VARCHAR(20);

    -- Đếm tổng số thẻ vàng cầu thủ đã nhận trong trận đấu hiện tại
    SELECT COUNT(*) INTO v_so_the_vang
    FROM the_phat
    WHERE id_tran = NEW.id_tran
      AND ma_dang_ky = NEW.ma_dang_ky
      AND loai_the = 'The vang';

    -- Nếu nhận thẻ đỏ trực tiếp HOẶC nhận thẻ vàng thứ 2 trong cùng trận
    IF NEW.loai_the = 'The do' OR (NEW.loai_the = 'The vang' AND v_so_the_vang = 2) THEN
        SELECT td.vong_dau, td.ma_mua_giai, dk.ma_doi_bong
        INTO v_vong_hien_tai, v_ma_mua_giai, v_ma_doi_bong
        FROM tran_dau td
        JOIN dang_ky_cau_thu dk ON dk.ma_dang_ky = NEW.ma_dang_ky
        WHERE td.id_tran = NEW.id_tran;

        -- Tìm trận đấu kế tiếp (vòng đấu + 1) của CLB đó trong cùng mùa giải
        SELECT id_tran INTO v_id_tran_ke_tiep
        FROM tran_dau
        WHERE ma_mua_giai = v_ma_mua_giai
          AND vong_dau = v_vong_hien_tai + 1
          AND (doi_nha = v_ma_doi_bong OR doi_khach = v_ma_doi_bong)
        LIMIT 1;

        -- Ghi nhận án phạt đình chỉ thi đấu nếu mùa giải còn vòng kế tiếp
        IF v_id_tran_ke_tiep IS NOT NULL THEN
            INSERT INTO an_phat (ma_an_phat, ly_do, trang_thai, ma_the, id_tran)
            VALUES (
                CONCAT('AP_', NEW.ma_the),
                CONCAT('Dinh chi thi dau vong ', v_vong_hien_tai + 1, ' do nhan ', NEW.loai_the, ' o tran ', NEW.id_tran),
                'Chua thi hanh',
                NEW.ma_the,
                v_id_tran_ke_tiep
            );
        END IF;
    END IF;
END;

CREATE TRIGGER trg_chan_cau_thu_bi_treo_gio
BEFORE INSERT ON tham_gia_tran_dau
FOR EACH ROW
BEGIN
    DECLARE v_bi_treo_gio INT DEFAULT 0;

    SELECT COUNT(*) INTO v_bi_treo_gio
    FROM an_phat ap
    JOIN the_phat tp ON ap.ma_the = tp.ma_the
    WHERE tp.ma_dang_ky = NEW.ma_dang_ky
      AND ap.id_tran = NEW.id_tran;

    IF v_bi_treo_gio > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nghiep vu: Cau thu dang bi dinh chi thi dau (treo gio) o tran dau nay!';
    END IF;
END;

CREATE TRIGGER trg_gioi_han_2_clb_mot_mua_insert
BEFORE INSERT ON dang_ky_cau_thu
FOR EACH ROW
BEGIN
    DECLARE v_so_clb INT DEFAULT 0;

    SELECT COUNT(DISTINCT ma_doi_bong) INTO v_so_clb
    FROM dang_ky_cau_thu
    WHERE ma_cau_thu = NEW.ma_cau_thu
      AND ma_mua_giai = NEW.ma_mua_giai
      AND ma_doi_bong <> NEW.ma_doi_bong;

    IF v_so_clb >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nghiep vu: Mot cau thu khong duoc thi dau cho qua 2 CLB trong cung mot mua giai!';
    END IF;
END;

CREATE TRIGGER trg_gioi_han_2_clb_mot_mua_update
BEFORE UPDATE ON dang_ky_cau_thu
FOR EACH ROW
BEGIN
    DECLARE v_so_clb INT DEFAULT 0;

    SELECT COUNT(DISTINCT ma_doi_bong) INTO v_so_clb
    FROM dang_ky_cau_thu
    WHERE ma_cau_thu = NEW.ma_cau_thu
      AND ma_mua_giai = NEW.ma_mua_giai
      AND ma_dang_ky <> OLD.ma_dang_ky
      AND ma_doi_bong <> NEW.ma_doi_bong;

    IF v_so_clb >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nghiep vu: Mot cau thu khong duoc thi dau cho qua 2 CLB trong cung mot mua giai!';
    END IF;
END;



