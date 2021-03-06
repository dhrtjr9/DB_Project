-- 항공사 
create table AIRLINE(
   L_NUMBER NUMBER(6),  
   L_NAME VARCHAR2(30), 
   L_ADDR VARCHAR2(100)
);
alter table AIRLINE add constraint AIRLINE_PK primary key(L_NUMBER);

-- 항공사부서 
create table AIRLINEDEPT(
   D_CODE NUMBER(6), --부서코드(PK) 
   D_NAME VARCHAR2(30), --부서명
   L_NUMBER NUMBER(6) --항공사번호(FK)
);
alter table AIRLINEDEPT add constraint AIRLINEDEPT_PK primary key(D_CODE);
alter table AIRLINEDEPT add constraint AIRLINEDEPT_AIRLINE_FK foreign key(L_NUMBER) references AIRLINE on delete cascade;

-- 직원 
create table EMP(
   E_NUMBER NUMBER(6),  -- 직원번호(PK)
   E_NAME VARCHAR2(30), -- 직원이름
   E_RANK VARCHAR2(30), -- 직급 
   D_CODE NUMBER(6)   -- 부서코드(FK)
);
alter table EMP add constraint EMP_PK primary key(E_NUMBER);
alter table EMP add constraint EMP_AIRLINEDEPT_FK foreign key(D_CODE) references  AIRLINEDEPT on delete cascade;

-- 비행스케줄
create table FLIGHTSCHEDULE(
   P_NUMBER NUMBER(6),  -- 비행번호(PK)
   P_DATE DATE,       -- 비행일자
   E_NUMBER NUMBER(6), -- 직원번호(FK)
   A_NUMBER VARCHAR2(30) -- 항공편명(FK)
);
alter table FLIGHTSCHEDULE add constraint FLIGHTSCHEDULE_PK primary key(P_NUMBER);
alter table FLIGHTSCHEDULE add constraint FLIGHTSCHEDULE_EMP_FK foreign key(E_NUMBER) references  EMP on delete cascade;
alter table FLIGHTSCHEDULE add constraint FLIGHTSCHEDULE_AIRPLANE_FK foreign key(A_NUMBER) references  AIRPLANE on delete cascade;

-- 비행기
create table AIRPLANE(
   A_NUMBER VARCHAR2(30),            -- 항공편명(PK) 
   A_WEIGHT NUMBER(6),            -- 무게
   A_SIZE NUMBER(6),            -- 크기 
   A_SPEED NUMBER(6),        -- 속도
   A_RECEIVE NUMBER(6)       -- 수용인원
);
alter table AIRPLANE add constraint AIRPLANE_PK primary key(A_NUMBER);

-- 운행
create table OPERATION(
   O_NUMBER NUMBER(6),       -- 운행번호(PK)  
   O_DATE DATE,             -- 운행일자
   A_NUMBER VARCHAR2(30),      -- 항공편명(FK)
   L_NUMBER NUMBER(6)  -- 항공사번호(FK)
);
alter table OPERATION add constraint OPERATION_PK primary key(O_NUMBER);
alter table OPERATION add constraint OPERATION_AIRPLANE_FK foreign key(A_NUMBER) references AIRPLANE;
alter table OPERATION add constraint OPERATION_AIRLINE_FK foreign key(L_NUMBER) references AIRLINE;

-- 좌석 
create table SEAT(
   S_NUMBER NUMBER(6),               -- 좌석번호(PK)
   A_NUMBER VARCHAR2(30),                -- 항공편명(PK, FK)
   S_GRADE CHAR            -- 등급
);
alter table SEAT add constraint SEAT_PK primary key(S_NUMBER, A_NUMBER);
alter table SEAT add constraint SEAT_AIRPLANE_FK foreign key(A_NUMBER) references AIRPLANE;   

-- 예약좌석
create table R_SEAT(
    R_S_NUMBER NUMBER(6),             -- 예약좌석번호(PK)
    S_NUMBER NUMBER(6),             -- 좌석번호(FK)
    A_NUMBER VARCHAR2(30)         -- 항공편명(FK)
);
alter table R_SEAT add constraint R_SEAT_PK primary key(R_S_NUMBER);
alter table R_SEAT add constraint R_SEAT_AIRPLANE_FK foreign key(A_NUMBER) references AIRPLANE;

-- 예매 
create table RESERVATION(
    R_NUMBER NUMBER(6),          -- 예매번호(PK) 
    R_DATE DATE,    -- 예매일자
    R_AMOUNT NUMBER(10),      -- 예매금액
    P_NUMBER NUMBER(6),     -- 승객번호(FK)
    R_S_NUMBER NUMBER(6),   -- 예약좌석번호(FK)
    S_NUMBER NUMBER(6)    -- 일정번호(FK)
);
alter table RESERVATION add constraint RESERVATION_PK primary key(R_NUMBER);
alter table RESERVATION add constraint RESERVATION_FLIGHTSCHEDULE_FK foreign key(P_NUMBER) references FLIGHTSCHEDULE;
alter table RESERVATION add constraint RESERVATION_R_SEAT_FK foreign key(R_S_NUMBER) references R_SEAT;
alter table RESERVATION add constraint RESERVATION_SCHEDULE_FK foreign key(S_NUMBER) references SCHEDULE;

-- 승객 
create table PASSENGER( 
    PA_NUMBER NUMBER(6),   -- 승객번호(PK)
    P_NAME VARCHAR2(30),     -- 승객이름
    P_ID VARCHAR2(20),         -- 아이디
    P_PWD VARCHAR2(20), -- 비밀번호
    P_CALL VARCHAR2(20), -- 전화번호
    P_PASSPORT VARCHAR2(20), -- 여권번호
    P_ADDR VARCHAR2(20) -- 주소
);
alter table PASSENGER add constraint PASSENGER_PK primary key(PA_NUMBER);

-- 수하물
create table LUGGAGE( 
    G_NUMBER NUMBER(6),   -- 수하물번호(PK)
    G_WEIGHT NUMBER(6),     -- 무게
    G_PRICE NUMBER(10),         -- 가격
    PA_NUMBER NUMBER(6) -- 승객번호(FK)
);
alter table LUGGAGE add constraint LUGGAGE_PK primary key(G_NUMBER);
alter table LUGGAGE add constraint LUGGAGE_PASSENGER_FK foreign key(PA_NUMBER) references PASSENGER;

-- 이용
create table USES( 
    U_NUMBER NUMBER(6),   -- 이용번호(PK)
    U_P_NUMBER NUMBER(6),     -- 승객번호(FK)
    P_NUMBER NUMBER(6),         -- 공항번호(FK)
    C_NUMBER NUMBER(6) -- 편의시설번호(FK)
);
alter table USES add constraint USES_PK primary key(U_NUMBER);
alter table USES add constraint USES_PASSENGER_FK foreign key(U_P_NUMBER) references PASSENGER;
alter table USES add constraint USES_AIRPORT_FK foreign key(P_NUMBER) references AIRPORT;
alter table USES add constraint USES_CONVENIENT_FK foreign key(C_NUMBER) references CONVENIENT;

-- 일정
create table SCHEDULE( 
    S_NUMBER NUMBER(6),   -- 일정번호(PK)
    S_DEPARTURE DATE,     -- 출발시각
    S_ARRIVE DATE,        -- 도착시각
    S_D_NUMBER NUMBER(6),         -- 출발공항번호(FK)
    S_A_NUMBER NUMBER(6), -- 도착공항번호(FK)
    F_NUMBER VARCHAR2(30)   -- 항공편명(FK)
);
alter table SCHEDULE add constraint SCHEDULE_PK primary key(S_NUMBER);
alter table SCHEDULE add constraint SCHEDULE_AIRPORT_FK foreign key(S_D_NUMBER) references AIRPORT;
alter table SCHEDULE add constraint SCHEDULE_AIRPORT_FK foreign key(S_A_NUMBER) references AIRPORT;
alter table SCHEDULE add constraint SCHEDULE_AIRPLANE_FK foreign key(F_NUMBER) references AIRPLANE;

-- 공항
create table AIRPORT( 
    P_NUMBER NUMBER(6),   -- 공항번호(PK)
    P_NAME VARCHAR2(30),     -- 공항명
    P_NATION VARCHAR2(30)         -- 국가명
);
alter table AIRPORT add constraint AIRPORT_PK primary key(P_NUMBER);

-- 제공
create table OFFER( 
    P_NUMBER NUMBER(6),   -- 공항번호(PK, FK)
    C_NUMBER NUMBER(6),     -- 편의시설번호(PK, FK)
    O_LOC VARCHAR2(20),         -- 위치
    O_TIME DATE -- 이용가능시간
);
alter table OFFER add constraint OFFER_PK primary key(P_NUMBER, C_NUMBER);
alter table OFFER add constraint OFFER_AIRPORT_FK foreign key(P_NUMBER) references AIRPORT;
alter table OFFER add constraint OFFER_CONVENIENT_FK foreign key(C_NUMBER) references CONVENIENT;

-- 편의시설
create table CONVENIENT( 
    C_NUMBER NUMBER(6),   -- 편의시설번호(PK)
    C_CATEGORY VARCHAR2(10)     -- 분류
);
alter table CONVENIENT add constraint CONVENIENT_PK primary key(C_NUMBER);


-- 확인 
select TNAME from TAB;
select SEQUENCE_NAME from SEQ;
select CONSTRAINT_NAME, CONSTRAINT_TYPE from user_constraints order by CONSTRAINT_NAME;