SET SERVEROUTPUT ON

--drop statements. ---
DROP TABLE Message CASCADE CONSTRAINT;
DROP TABLE Review CASCADE CONSTRAINT;
DROP TABLE Paper_Bid CASCADE CONSTRAINT;
DROP TABLE Registration CASCADE CONSTRAINT;
DROP TABLE Paper_Topic CASCADE CONSTRAINT;
DROP TABLE Paper_Author CASCADE CONSTRAINT;
DROP TABLE User_Roles CASCADE CONSTRAINT;
DROP TABLE Conference_Session CASCADE CONSTRAINT;
DROP TABLE Paper CASCADE CONSTRAINT;
DROP TABLE Topic CASCADE CONSTRAINT;
DROP TABLE Conference CASCADE CONSTRAINT;
DROP TABLE Users CASCADE CONSTRAINT;
DROP TABLE Institution CASCADE CONSTRAINT;
--create statements --
CREATE TABLE Institution (
    Institution_ID NUMBER PRIMARY KEY,
    Institution_Name VARCHAR2(255) NOT NULL,
    Country VARCHAR2(100) NOT NULL
);
CREATE TABLE Users (
    User_ID NUMBER PRIMARY KEY,
    Institution_ID NUMBER NOT NULL,
    Name VARCHAR2(255) NOT NULL,
    Address VARCHAR2(255),
    Zipcode VARCHAR2(10),
    Email VARCHAR2(255) UNIQUE,
    Country VARCHAR2(100),
    FOREIGN KEY (Institution_ID) REFERENCES Institution(Institution_ID)
);
CREATE TABLE Conference (
    Conference_ID NUMBER PRIMARY KEY,
    Title VARCHAR2(255) NOT NULL,
    Year NUMBER(4) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Submission_Due TIMESTAMP NOT NULL,
    Review_Due TIMESTAMP NOT NULL,
    Camera_Ready_Due TIMESTAMP,
    City VARCHAR2(100),
    Country VARCHAR2(100),
    Early_Registration_Date DATE,
    Early_Registration_Fee NUMBER(10,2),
    Regular_Registration_Fee NUMBER(10,2)
);
select * from conference
CREATE TABLE Conference_Session (
    Session_ID NUMBER PRIMARY KEY,
    Conference_ID NUMBER NOT NULL,
    User_ID NUMBER NOT NULL,
    Title VARCHAR2(255) NOT NULL,
    Start_Time TIMESTAMP NOT NULL,
    End_Time TIMESTAMP NOT NULL,
    FOREIGN KEY (Conference_ID) REFERENCES Conference(Conference_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);
CREATE TABLE User_Roles (
    User_ID NUMBER NOT NULL,
    Conference_ID NUMBER NOT NULL,
    Role VARCHAR2(50) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Conference_ID) REFERENCES Conference(Conference_ID),
    PRIMARY KEY (User_ID, Conference_ID, Role)
);
CREATE TABLE Paper (
    Paper_ID NUMBER PRIMARY KEY,
    Conference_ID NUMBER NOT NULL,
    Title VARCHAR2(255) NOT NULL,
    Submit_Time TIMESTAMP,
    Avg_Review_Score NUMBER(5,2),
    Status VARCHAR2(20) CHECK (Status IN ('submitted', 'under review', 'accepted', 'rejected', 'camera ready received')),
    Session_ID NUMBER,

    FOREIGN KEY (Conference_ID) REFERENCES Conference(Conference_ID),
    FOREIGN KEY (Session_ID) REFERENCES Conference_Session(Session_ID)
);
select * from topic;
CREATE TABLE Paper_Author (
    Paper_ID NUMBER NOT NULL,
    User_ID NUMBER NOT NULL,
    Author_Order NUMBER NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Paper_ID) REFERENCES Paper(Paper_ID),
    PRIMARY KEY (Paper_ID, User_ID)
);
CREATE TABLE Topic (
    Topic_ID NUMBER PRIMARY KEY,
    Topic_Name VARCHAR2(255) NOT NULL
);
CREATE TABLE Paper_Topic (
    Paper_ID NUMBER NOT NULL,
    Topic_ID NUMBER NOT NULL,
    FOREIGN KEY (Paper_ID) REFERENCES Paper(Paper_ID),
    FOREIGN KEY (Topic_ID) REFERENCES Topic(Topic_ID),
    PRIMARY KEY (Paper_ID, Topic_ID)
);
CREATE TABLE Paper_Bid (
    Bid_ID NUMBER PRIMARY KEY,
    User_ID NUMBER NOT NULL,
    Paper_ID NUMBER NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Paper_ID) REFERENCES Paper(Paper_ID)
);
CREATE TABLE Review (
    Review_ID NUMBER PRIMARY KEY,
    User_ID NUMBER NOT NULL,
    Paper_ID NUMBER NOT NULL,
    Review_Score NUMBER(5,2),
    Comments VARCHAR2(1000),
    Upload_Time TIMESTAMP NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Paper_ID) REFERENCES Paper(Paper_ID)
);
CREATE TABLE Registration (
    Registration_ID NUMBER PRIMARY KEY,
    Conference_ID NUMBER NOT NULL,
    User_ID NUMBER NOT NULL,
    Registration_Fee NUMBER(10,2) NOT NULL,
    Payment_Date DATE,
    Payment_Status VARCHAR2(10) CHECK (Payment_Status IN ('paid', 'not paid')),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Conference_ID) REFERENCES Conference(Conference_ID)
);
CREATE TABLE Message (
    Message_ID NUMBER PRIMARY KEY,
    User_ID NUMBER NOT NULL,
    Message_Time TIMESTAMP NOT NULL,
    Message_Body VARCHAR2(1000),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);
-- insert statements --
INSERT INTO Institution (Institution_ID, Institution_Name, Country) VALUES (1, 'Stanford University', 'USA');
INSERT INTO Institution (Institution_ID, Institution_Name, Country) VALUES (2, 'MIT', 'USA');
INSERT INTO Institution (Institution_ID, Institution_Name, Country) VALUES (3, 'University of Cambridge', 'UK');
INSERT INTO Institution (Institution_ID, Institution_Name, Country) VALUES (4, 'Oxford University', 'UK');
INSERT INTO Institution (Institution_ID, Institution_Name, Country) VALUES (5, 'Google', 'USA');

 
INSERT INTO Conference (Conference_ID, Title, Year, Start_Date, End_Date, Submission_Due, Review_Due, Camera_Ready_Due, City, Country,
Early_Registration_Date, Early_Registration_Fee, Regular_Registration_Fee)
VALUES (1, 'AI Conference', 2024, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-05-01 23:59:
59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-20 23:59:59', 'YYYY-MM-DD
HH24:MI:SS'), 'Palo Alto', 'USA', TO_DATE('2024-05-15', 'YYYY-MM-DD'), 200.00, 300.00);
INSERT INTO Conference (Conference_ID, Title, Year, Start_Date, End_Date, Submission_Due, Review_Due, Camera_Ready_Due, City, Country,
Early_Registration_Date, Early_Registration_Fee, Regular_Registration_Fee)
VALUES (2, 'Quantum Computing Summit', 2024, TO_DATE('2024-08-15', 'YYYY-MM-DD'), TO_DATE('2024-08-18', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-06-
15 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-10 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-30 23:59:59',
'YYYY-MM-DD HH24:MI:SS'), 'Cambridge', 'UK', TO_DATE('2024-06-20', 'YYYY-MM-DD'), 150.00, 250.00);
INSERT INTO Conference (Conference_ID, Title, Year, Start_Date, End_Date, Submission_Due, Review_Due, Camera_Ready_Due, City, Country,
Early_Registration_Date, Early_Registration_Fee, Regular_Registration_Fee)
VALUES (3, 'Cybersecurity World', 2024, TO_DATE('2024-09-10', 'YYYY-MM-DD'), TO_DATE('2024-09-12', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-07-05 23:
59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-20 23:59:59', 'YYYY-MM-
DD HH24:MI:SS'), 'Oxford', 'UK', TO_DATE('2024-07-25', 'YYYY-MM-DD'), 175.00, 275.00);
INSERT INTO Conference (Conference_ID, Title, Year, Start_Date, End_Date, Submission_Due, Review_Due, Camera_Ready_Due, City, Country,
Early_Registration_Date, Early_Registration_Fee, Regular_Registration_Fee)
VALUES (4, 'Big Data Expo', 2024, TO_DATE('2024-10-05', 'YYYY-MM-DD'), TO_DATE('2024-10-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-08-01 23:59:
59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-20 23:59:59', 'YYYY-MM-DD
HH24:MI:SS'), 'New York', 'USA', TO_DATE('2024-08-15', 'YYYY-MM-DD'), 250.00, 350.00);
INSERT INTO Conference (Conference_ID, Title, Year, Start_Date, End_Date, Submission_Due, Review_Due, Camera_Ready_Due, City, Country,
Early_Registration_Date, Early_Registration_Fee, Regular_Registration_Fee)
VALUES (5, 'Blockchain Technology Conference', 2024, TO_DATE('2024-11-12', 'YYYY-MM-DD'), TO_DATE('2024-11-14', 'YYYY-MM-DD'), TO_TIMESTAMP
('2024-09-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-20 23:59:
59', 'YYYY-MM-DD HH24:MI:SS'), 'San Francisco', 'USA', TO_DATE('2024-09-15', 'YYYY-MM-DD'), 300.00, 400.00);
INSERT INTO Conference_Session (Session_ID, Conference_ID, User_ID, Title, Start_Time, End_Time)
VALUES (1, 1, 1, 'AI Ethics', TO_TIMESTAMP('2024-07-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-01 12:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO Conference_Session (Session_ID, Conference_ID, User_ID, Title, Start_Time, End_Time)
VALUES (2, 1, 2, 'AI in Healthcare', TO_TIMESTAMP('2024-07-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-01 16:00:00', 'YYYY-
MM-DD HH24:MI:SS'));
INSERT INTO Conference_Session (Session_ID, Conference_ID, User_ID, Title, Start_Time, End_Time)
VALUES (3, 2, 3, 'Quantum Algorithms', TO_TIMESTAMP('2024-08-16 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-16 12:00:00', 'YYYY-
MM-DD HH24:MI:SS'));
INSERT INTO Conference_Session (Session_ID, Conference_ID, User_ID, Title, Start_Time, End_Time)
VALUES (4, 2, 4, 'Quantum Cryptography', TO_TIMESTAMP('2024-08-16 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-16 16:00:00',
'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Conference_Session (Session_ID, Conference_ID, User_ID, Title, Start_Time, End_Time)
VALUES (5, 3, 5, 'AI in Cybersecurity', TO_TIMESTAMP('2024-09-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-10 12:00:00',
'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO Paper_Author (Paper_ID, User_ID, Author_Order)
VALUES (1, 2, 1);
INSERT INTO Paper_Author (Paper_ID, User_ID, Author_Order)
VALUES (2, 1, 1);
INSERT INTO Paper_Author (Paper_ID, User_ID, Author_Order)
VALUES (3, 3, 1);
INSERT INTO Paper_Author (Paper_ID, User_ID, Author_Order)
VALUES (4, 4, 1);
INSERT INTO Paper_Author (Paper_ID, User_ID, Author_Order)
VALUES (5, 5, 1);
INSERT INTO Topic (Topic_ID, Topic_Name)
VALUES (1, 'Artificial Intelligence');
INSERT INTO Topic (Topic_ID, Topic_Name)
VALUES (2, 'Quantum Computing');
INSERT INTO Topic (Topic_ID, Topic_Name)
VALUES (3, 'Cybersecurity');
INSERT INTO Topic (Topic_ID, Topic_Name)
VALUES (4, 'Big Data');
INSERT INTO Topic (Topic_ID, Topic_Name)
VALUES (5, 'Blockchain');
INSERT INTO Paper_Topic (Paper_ID, Topic_ID)
VALUES (1, 1);
INSERT INTO Paper_Topic (Paper_ID, Topic_ID)
VALUES (2, 1);
INSERT INTO Paper_Topic (Paper_ID, Topic_ID)
VALUES (3, 2);
INSERT INTO Paper_Topic (Paper_ID, Topic_ID)
VALUES (4, 3);
INSERT INTO Paper_Topic (Paper_ID, Topic_ID)
VALUES (5, 4);
select * from paper_topic;



INSERT INTO Review (Review_ID, User_ID, Paper_ID, Review_Score, Comments, Upload_Time)
VALUES (1, 3, 1, 4.5, 'Great paper!', TO_TIMESTAMP('2024-06-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Review (Review_ID, User_ID, Paper_ID, Review_Score, Comments, Upload_Time)
VALUES (2, 4, 2, 4.0, 'Interesting approach.', TO_TIMESTAMP('2024-06-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Review (Review_ID, User_ID, Paper_ID, Review_Score, Comments, Upload_Time)
VALUES (3, 5, 3, 3.5, 'Needs improvement.', TO_TIMESTAMP('2024-06-07 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Review (Review_ID, User_ID, Paper_ID, Review_Score, Comments, Upload_Time)
VALUES (4, 1, 4, 4.8, 'Excellent paper!', TO_TIMESTAMP('2024-06-08 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Review (Review_ID, User_ID, Paper_ID, Review_Score, Comments, Upload_Time)
VALUES (5, 2, 5, 4.2, 'Well-written.', TO_TIMESTAMP('2024-06-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Registration (Registration_ID, Conference_ID, User_ID, Registration_Fee, Payment_Date, Payment_Status)
VALUES (1, 1, 1, 200.00, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'paid');
INSERT INTO Registration (Registration_ID, Conference_ID, User_ID, Registration_Fee, Payment_Date, Payment_Status)
VALUES (2, 2, 2, 150.00, TO_DATE('2024-06-12', 'YYYY-MM-DD'), 'paid');
INSERT INTO Registration (Registration_ID, Conference_ID, User_ID, Registration_Fee, Payment_Date, Payment_Status)
VALUES (3, 3, 3, 175.00, TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'paid');
INSERT INTO Registration (Registration_ID, Conference_ID, User_ID, Registration_Fee, Payment_Date, Payment_Status)
VALUES (4, 4, 4, 250.00, TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'not paid');
INSERT INTO Registration (Registration_ID, Conference_ID, User_ID, Registration_Fee, Payment_Date, Payment_Status)
VALUES (5, 5, 5, 300.00, TO_DATE('2024-09-25', 'YYYY-MM-DD'), 'paid');
INSERT INTO Message (Message_ID, User_ID, Message_Time, Message_Body)
VALUES (1, 1, TO_TIMESTAMP('2024-06-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Reminder: Paper submission due for AI Conference');
INSERT INTO Message (Message_ID, User_ID, Message_Time, Message_Body)
VALUES (2, 2, TO_TIMESTAMP('2024-06-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Reminder: Early registration for Quantum Computing Summit');
INSERT INTO Message (Message_ID, User_ID, Message_Time, Message_Body)
VALUES (3, 3, TO_TIMESTAMP('2024-06-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paper submission received for Quantum Computing Summit');
INSERT INTO Message (Message_ID, User_ID, Message_Time, Message_Body)
VALUES (4, 4, TO_TIMESTAMP('2024-06-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paper review due for Cybersecurity World');
INSERT INTO Message (Message_ID, User_ID, Message_Time, Message_Body)
VALUES (5, 5, TO_TIMESTAMP('2024-06-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Your review for Big Data Expo is overdue');


--member 1 feature 1:
drop sequence user_id_seq;
CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE add_user(
    p_name IN VARCHAR2,
    p_institution_id IN NUMBER,
    p_address IN VARCHAR2,
    p_zipcode IN VARCHAR2,
    p_email IN VARCHAR2,
    p_country IN VARCHAR2
) AS
    v_user_id NUMBER;
    v_email_exists NUMBER;
BEGIN
    -- Check if a user with the same email already exists
    SELECT COUNT(*)
    INTO v_email_exists
    FROM Users
    WHERE Email = p_email;

    IF v_email_exists > 0 THEN
        -- Update the user's address, zipcode, and country
        UPDATE Users
        SET Address = p_address,
            Zipcode = p_zipcode,
            Country = p_country
        WHERE Email = p_email;

        DBMS_OUTPUT.PUT_LINE('The user already exists. Address, zipcode, and country updated.');
    ELSE
        SELECT user_id_seq.NEXTVAL INTO v_user_id FROM DUAL;

        INSERT INTO Users (
            User_ID, Institution_ID, Name, Address, Zipcode, Email, Country
        )
        VALUES (
            v_user_id, p_institution_id, p_name, p_address, p_zipcode, p_email, p_country
        );

        DBMS_OUTPUT.PUT_LINE('New user added with User ID: ' || v_user_id);
    END IF;
END;
/
BEGIN
    add_user('John Doe', 1, '456 Innovation St, Palo Alto', '94302', 'john.doe@stanford.edu', 'USA');
    add_user('Jane Smith', 2, '789 Research Blvd, Cambridge', '02140', 'jane.smith@mit.edu', 'USA');
    add_user('Emily Clark', 3, '101 Kings Parade, Cambridge', 'CB21TQ', 'emily.clark@cam.ac.uk', 'UK');
    add_user('Michael Brown', 4, '98 High St, Oxford', 'OX13DY', 'michael.brown@ox.ac.uk', 'UK');
    add_user('Sophia Davis', 5, '1601 Amphitheatre Pkwy, Mountain View', '94043', 'sophia.davis@google.com', 'USA');
END;
/

select * from users;
-- member 1 feature 2:
CREATE OR REPLACE TYPE role_array AS VARRAY(10) OF VARCHAR2(50);
/

CREATE OR REPLACE PROCEDURE add_user_roles(
    p_user_id IN NUMBER,
    p_conference_id IN NUMBER,
    p_roles IN role_array
) AS
    v_user_exists NUMBER;
    v_conference_exists NUMBER;
    v_role VARCHAR2(50);
    v_role_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_user_exists
    FROM Users
    WHERE User_ID = p_user_id;

    SELECT COUNT(*)
    INTO v_conference_exists
    FROM Conference
    WHERE Conference_ID = p_conference_id;

    IF v_user_exists = 0 OR v_conference_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid user or conference ID.');
        RETURN;
    END IF;

    FOR i IN 1..p_roles.COUNT LOOP
        v_role := p_roles(i);

        SELECT COUNT(*)
        INTO v_role_exists
        FROM User_Roles
        WHERE User_ID = p_user_id
          AND Conference_ID = p_conference_id
          AND Role = v_role;

        IF v_role_exists > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Role "' || v_role || '" already exists for the user.');
        ELSE
            INSERT INTO User_Roles (User_ID, Conference_ID, Role)
            VALUES (p_user_id, p_conference_id, v_role);

            DBMS_OUTPUT.PUT_LINE('Role "' || v_role || '" added for the user.');
        END IF;
    END LOOP;
END;
/
DECLARE
    roles role_array := role_array('Organizer');
BEGIN
    add_user_roles(1, 1, roles);
    
    roles := role_array('Author');
    add_user_roles(2, 1, roles);
    
    roles := role_array('Reviewer');
    add_user_roles(3, 2, roles);
    
    roles := role_array('Participant');
    add_user_roles(4, 2, roles);
    
    roles := role_array('Reviewer');
    add_user_roles(5, 3, roles);
END;
/
select * from user_roles;
-- member 2 Feature3:
drop sequence paper_id_seq
CREATE SEQUENCE paper_id_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE add_paper(
    p_conference_id IN NUMBER,
    p_title IN VARCHAR2,
    p_submit_time IN TIMESTAMP,
    p_author_ids IN sys.odcinumberlist, -- Array of author user IDs
    p_topic_ids IN sys.odcinumberlist   -- Array of topic IDs
) AS
    v_paper_id NUMBER;
    v_paper_exists NUMBER;
    v_conference_exists NUMBER;
    v_topic_exists NUMBER;
    v_user_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_conference_exists
    FROM Conference
    WHERE Conference_ID = p_conference_id;

    IF v_conference_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid conference ID.');
        RETURN;
    END IF;

    -- Step 2: Check if a paper with the same title exists for the conference
    SELECT COUNT(*)
    INTO v_paper_exists
    FROM Paper
    WHERE Conference_ID = p_conference_id
      AND Title = p_title;

    IF v_paper_exists > 0 THEN
        -- Update submission time if the paper exists
        UPDATE Paper
        SET Submit_Time = p_submit_time
        WHERE Conference_ID = p_conference_id
          AND Title = p_title;

        DBMS_OUTPUT.PUT_LINE('Paper exists, submission time updated.');
    ELSE
        SELECT paper_id_seq.NEXTVAL INTO v_paper_id FROM DUAL;

        INSERT INTO Paper (
            Paper_ID, Conference_ID, Title, Submit_Time, Status, Session_ID
        )
        VALUES (
            v_paper_id, p_conference_id, p_title, p_submit_time, 'submitted', NULL
        );

        DBMS_OUTPUT.PUT_LINE('New paper added with Paper ID: ' || v_paper_id);
    END IF;

    -- Step 3: Handle topics
    FOR i IN 1..p_topic_ids.COUNT LOOP
        -- Check if the topic ID is valid
        SELECT COUNT(*)
        INTO v_topic_exists
        FROM Topic
        WHERE Topic_ID = p_topic_ids(i);

        IF v_topic_exists > 0 THEN
            -- Insert paper-topic pair if it doesn't already exist
            SELECT COUNT(*)
            INTO v_paper_exists
            FROM Paper_Topic
            WHERE Paper_ID = v_paper_id
              AND Topic_ID = p_topic_ids(i);

            IF v_paper_exists = 0 THEN
                INSERT INTO Paper_Topic (Paper_ID, Topic_ID)
                VALUES (v_paper_id, p_topic_ids(i));

                DBMS_OUTPUT.PUT_LINE('Paper-topic pair added for Topic ID: ' || p_topic_ids(i));
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid Topic ID: ' || p_topic_ids(i));
        END IF;
    END LOOP;

    DELETE FROM Paper_Author
    WHERE Paper_ID = v_paper_id;

    DBMS_OUTPUT.PUT_LINE('Old authors removed for Paper ID: ' || v_paper_id);

    FOR i IN 1..p_author_ids.COUNT LOOP
        -- Check if the user ID is valid
        SELECT COUNT(*)
        INTO v_user_exists
        FROM Users
        WHERE User_ID = p_author_ids(i);

        IF v_user_exists > 0 THEN
            -- Insert paper-author pair
            INSERT INTO Paper_Author (Paper_ID, User_ID, Author_Order)
            VALUES (v_paper_id, p_author_ids(i), i);

            DBMS_OUTPUT.PUT_LINE('Paper-author pair added for User ID: ' || p_author_ids(i));
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid User ID: ' || p_author_ids(i));
        END IF;
    END LOOP;
END;
/

DECLARE
    author_ids SYS.ODCINUMBERLIST;
    topic_ids  SYS.ODCINUMBERLIST;
BEGIN
    -- Add the first paper
    author_ids := SYS.ODCINUMBERLIST(1);
    topic_ids  := SYS.ODCINUMBERLIST(1); -- Assuming topic ID 1 corresponds to 'AI'
    add_paper(1, 'AI for Good', TO_TIMESTAMP('2024-04-30 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), author_ids, topic_ids);

    -- Add the second paper
    author_ids := SYS.ODCINUMBERLIST(2);
    topic_ids  := SYS.ODCINUMBERLIST(2); -- Assuming topic ID 2 corresponds to 'Medicine'
    add_paper(1, 'AI in Medicine', TO_TIMESTAMP('2024-04-30 23:30:00', 'YYYY-MM-DD HH24:MI:SS'), author_ids, topic_ids);

    -- Add the third paper
    author_ids := SYS.ODCINUMBERLIST(3);
    topic_ids  := SYS.ODCINUMBERLIST(3); -- Assuming topic ID 3 corresponds to 'Quantum Computing'
    add_paper(2, 'Quantum Machine Learning', TO_TIMESTAMP('2024-06-10 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), author_ids, topic_ids);

    -- Add the fourth paper
    author_ids := SYS.ODCINUMBERLIST(4);
    topic_ids  := SYS.ODCINUMBERLIST(4); -- Assuming topic ID 4 corresponds to 'Cybersecurity'
    add_paper(3, 'Cybersecurity using AI', TO_TIMESTAMP('2024-07-01 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), author_ids, topic_ids);

    -- Add the fifth paper
    author_ids := SYS.ODCINUMBERLIST(5);
    topic_ids  := SYS.ODCINUMBERLIST(5); -- Assuming topic ID 5 corresponds to 'Big Data'
    add_paper(4, 'Big Data in Medicine', TO_TIMESTAMP('2024-08-01 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), author_ids, topic_ids);

    DBMS_OUTPUT.PUT_LINE('Papers added successfully.');
END;
/


select * from paper;

--member 3 feature 4:
drop sequence paper_bid_seq;
CREATE SEQUENCE paper_bid_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE list_papers_by_conf_and_topic(
    p_conf_id  IN NUMBER,
    p_topic_id IN NUMBER
) AS
    v_conf_exists  NUMBER;
    v_topic_exists NUMBER;
BEGIN
    -- Check if the conference ID exists
    SELECT COUNT(*)
    INTO v_conf_exists
    FROM Conference
    WHERE Conference_ID = p_conf_id;

    IF v_conf_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid conference ID: ' || p_conf_id);
        RETURN;
    END IF;

    -- Check if the topic ID exists
    SELECT COUNT(*)
    INTO v_topic_exists
    FROM Topic
    WHERE Topic_ID = p_topic_id;

    IF v_topic_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid topic ID: ' || p_topic_id);
        RETURN;
    END IF;

    -- Retrieve and display papers matching the conference and topic
    FOR rec IN (
        SELECT p.Paper_ID, p.Title
        FROM Paper p
        JOIN Paper_Topic pt ON p.Paper_ID = pt.Paper_ID
        WHERE p.Conference_ID = p_conf_id
          AND pt.Topic_ID = p_topic_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Paper ID: ' || rec.Paper_ID || ', Title: ' || rec.Title);
    END LOOP;
END;
/


BEGIN
    list_papers_by_conf_and_topic(1,1);
END;
/

-- Feature 5:

CREATE OR REPLACE PROCEDURE enter_paper_bids(
    p_user_id IN NUMBER,
    p_paper_ids IN sys.odcinumberlist 
) AS
    v_user_exists NUMBER;
    v_paper_exists NUMBER;
    v_bid_id NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_user_exists
    FROM Users
    WHERE User_ID = p_user_id;

    IF v_user_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid user ID.');
        RETURN;
    END IF;

    FOR i IN 1..p_paper_ids.COUNT LOOP
        -- Check if the paper ID is valid
        SELECT COUNT(*)
        INTO v_paper_exists
        FROM Paper
        WHERE Paper_ID = p_paper_ids(i);

        IF v_paper_exists = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Invalid paper ID: ' || p_paper_ids(i));
        ELSE
            SELECT paper_bid_seq.NEXTVAL INTO v_bid_id FROM DUAL;

            -- Insert the bid into the Paper_Bid table
            INSERT INTO Paper_Bid (Bid_ID, User_ID, Paper_ID)
            VALUES (v_bid_id, p_user_id, p_paper_ids(i));

            DBMS_OUTPUT.PUT_LINE('Bid entered for Paper ID: ' || p_paper_ids(i) || ' with Bid ID: ' || v_bid_id);
        END IF;
    END LOOP;
END;
/

BEGIN
    enter_paper_bids(
        p_user_id   => 1,
        p_paper_ids => SYS.ODCINUMBERLIST(1, 2, 3)
    );
END;
/
select * from paper_bid;

--member 4 feature 6:
drop sequence review_id_seq;
create sequence review_id_seq start with 1;
CREATE OR REPLACE PROCEDURE enter_review(
    p_user_id IN NUMBER,
    p_paper_id IN NUMBER,
    p_review_score IN NUMBER,
    p_review_comment IN VARCHAR2,
    p_upload_time IN TIMESTAMP
) AS
    v_user_exists NUMBER;
    v_paper_exists NUMBER;
    v_is_reviewer NUMBER;
    v_coi_exists NUMBER;
    v_review_exists NUMBER;
    v_review_id NUMBER;
    v_conference_id NUMBER;
BEGIN
    -- Step 1: Check if the user ID and paper ID are valid
    SELECT COUNT(*)
    INTO v_user_exists
    FROM Users
    WHERE User_ID = p_user_id;

    SELECT COUNT(*)
    INTO v_paper_exists
    FROM Paper
    WHERE Paper_ID = p_paper_id;

    IF v_user_exists = 0 OR v_paper_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid user ID or paper ID.');
        RETURN;
    END IF;

    -- Step 2: Check if the user is a reviewer for the conference the paper is submitted to
    SELECT Conference_ID
    INTO v_conference_id
    FROM Paper
    WHERE Paper_ID = p_paper_id;

    SELECT COUNT(*)
    INTO v_is_reviewer
    FROM User_Roles
    WHERE User_ID = p_user_id
      AND Conference_ID = v_conference_id
      AND Role = 'Reviewer';

    IF v_is_reviewer = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The user is not a reviewer.');
        RETURN;
    END IF;

    -- Step 3: Check for conflict of interest (COI)
    SELECT COUNT(*)
    INTO v_coi_exists
    FROM Paper_Author pa
    JOIN Users u ON pa.User_ID = u.User_ID
    WHERE pa.Paper_ID = p_paper_id
      AND u.Institution_ID = (SELECT Institution_ID FROM Users WHERE User_ID = p_user_id);

    IF v_coi_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('A COI exists.');
        RETURN;
    END IF;

    -- Step 4: Check if a review already exists
    SELECT COUNT(*)
    INTO v_review_exists
    FROM Review
    WHERE User_ID = p_user_id
      AND Paper_ID = p_paper_id;

    IF v_review_exists > 0 THEN
        -- Update the existing review
        UPDATE Review
        SET Review_Score = p_review_score,
            Comments = p_review_comment,
            Upload_Time = p_upload_time
        WHERE User_ID = p_user_id
          AND Paper_ID = p_paper_id;

        DBMS_OUTPUT.PUT_LINE('Update existing review.');
    ELSE
        -- Insert a new review
        SELECT review_id_seq.NEXTVAL INTO v_review_id FROM DUAL;

        INSERT INTO Review (
            Review_ID, User_ID, Paper_ID, Review_Score, Comments, Upload_Time
        )
        VALUES (
            v_review_id, p_user_id, p_paper_id, p_review_score, p_review_comment, p_upload_time
        );

        DBMS_OUTPUT.PUT_LINE('Review added.');
    END IF;
END;
/
BEGIN
    enter_review(
        p_user_id       => 1,  -- Replace with the actual User ID
        p_paper_id      => 2,  -- Replace with the actual Paper ID
        p_review_score  => 4,  -- Replace with the actual review score
        p_review_comment=> 'Comprehensive analysis with minor revisions needed.',  -- Replace with the actual review comment
        p_upload_time   => SYSTIMESTAMP  -- Current timestamp
    );
END;
/


--group features
-- feature 
--feature 9: 


CREATE OR REPLACE PROCEDURE assign_paper_to_reviewer(
    p_paper_id          IN NUMBER,
    p_max_papers_per_reviewer IN NUMBER
) AS
    CURSOR reviewer_cursor IS
        SELECT ur.User_ID
        FROM User_Roles ur
        JOIN Users u ON ur.User_ID = u.User_ID
        WHERE ur.Role = 'Reviewer'
          AND ur.Conference_ID = (SELECT Conference_ID FROM Paper WHERE Paper_ID = p_paper_id)
          AND NOT EXISTS (
              SELECT 1
              FROM Paper_Author pa
              JOIN Users au ON pa.User_ID = au.User_ID
              WHERE pa.Paper_ID = p_paper_id
                AND au.Institution_ID = u.Institution_ID
          )
          AND NOT EXISTS (
              SELECT 1
              FROM Review r
              WHERE r.Paper_ID = p_paper_id
                AND r.User_ID = ur.User_ID
          );

    v_reviewer_id       Users.User_ID%TYPE;
    v_review_id         Review.Review_ID%TYPE;
    v_paper_exists      NUMBER;
    v_reviewer_count    NUMBER;
BEGIN
    -- Check if the paper ID is valid
    SELECT COUNT(*)
    INTO v_paper_exists
    FROM Paper
    WHERE Paper_ID = p_paper_id;

    IF v_paper_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid paper ID: ' || p_paper_id);
        RETURN;
    END IF;

    -- Iterate through potential reviewers
    FOR reviewer_rec IN reviewer_cursor LOOP
        v_reviewer_id := reviewer_rec.User_ID;

        -- Check if the reviewer has reached the maximum number of papers
        SELECT COUNT(*)
        INTO v_reviewer_count
        FROM Review r
        JOIN Paper p ON r.Paper_ID = p.Paper_ID
        WHERE r.User_ID = v_reviewer_id
          AND p.Conference_ID = (SELECT Conference_ID FROM Paper WHERE Paper_ID = p_paper_id);

        IF v_reviewer_count < p_max_papers_per_reviewer THEN
            -- Check if the reviewer has bid for the paper
            DECLARE
                v_bid_count NUMBER;
            BEGIN
                SELECT COUNT(*)
                INTO v_bid_count
                FROM Paper_Bid pb
                WHERE pb.Paper_ID = p_paper_id
                  AND pb.User_ID = v_reviewer_id;

                IF v_bid_count > 0 THEN
                    -- Assign to the reviewer who has bid
                    SELECT review_id_seq.NEXTVAL INTO v_review_id FROM DUAL;
                    INSERT INTO Review (Review_ID, User_ID, Paper_ID)
                    VALUES (v_review_id, v_reviewer_id, p_paper_id);
                    DBMS_OUTPUT.PUT_LINE('Assigned to user ' || v_reviewer_id || ' who bid for the paper.');
                    RETURN;
                END IF;
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('User ' || v_reviewer_id || ' has reached capacity.');
        END IF;
    END LOOP;

    -- If no reviewer who bid was assigned, assign to any available reviewer
    FOR reviewer_rec IN reviewer_cursor LOOP
        v_reviewer_id := reviewer_rec.User_ID;

        -- Check if the reviewer has reached the maximum number of papers
        SELECT COUNT(*)
        INTO v_reviewer_count
        FROM Review r
        JOIN Paper p ON r.Paper_ID = p.Paper_ID
        WHERE r.User_ID = v_reviewer_id
          AND p.Conference_ID = (SELECT Conference_ID FROM Paper WHERE Paper_ID = p_paper_id);

        IF v_reviewer_count < p_max_papers_per_reviewer THEN
            -- Assign to the reviewer
            SELECT review_id_seq.NEXTVAL INTO v_review_id FROM DUAL;
            INSERT INTO Review (Review_ID, User_ID, Paper_ID)
            VALUES (v_review_id, v_reviewer_id, p_paper_id);
            DBMS_OUTPUT.PUT_LINE('Assigned to user ' || v_reviewer_id);
            RETURN;
        ELSE
            DBMS_OUTPUT.PUT_LINE('User ' || v_reviewer_id || ' has reached capacity.');
        END IF;
    END LOOP;

    -- If no reviewer was assigned
    DBMS_OUTPUT.PUT_LINE('No suitable reviewer found for paper ID: ' || p_paper_id);
END;
/
select * from paper;
BEGIN
    assign_paper_to_reviewer(2,3);
END;
/



--feature 11:
drop sequence message_seq;
create sequence message_seq start with 1 increment by 1;
CREATE OR REPLACE PROCEDURE send_registration_reminder(
    p_conference_id IN NUMBER
) AS
    v_conf_exists NUMBER;
    v_early_reg_date DATE;
    v_conf_title VARCHAR2(255);
    v_max_message_id NUMBER;
BEGIN
    -- Step 1: Validate the conference ID
    SELECT COUNT(*)
    INTO v_conf_exists
    FROM Conference
    WHERE Conference_ID = p_conference_id;

    IF v_conf_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid conference ID: ' || p_conference_id);
        RETURN;
    END IF;

    -- Retrieve the early registration date and conference title for the conference
    SELECT Early_Registration_Date, Title
    INTO v_early_reg_date, v_conf_title
    FROM Conference
    WHERE Conference_ID = p_conference_id;

    -- Initialize the maximum Message_ID
    SELECT NVL(MAX(Message_ID), 0)
    INTO v_max_message_id
    FROM Message;

    -- Step 2: Identify accepted papers without registered authors
    FOR paper_rec IN (
        SELECT p.Paper_ID, p.Title AS Paper_Title
        FROM Paper p
        WHERE p.Conference_ID = p_conference_id
          AND p.Status = 'submitted'
          AND NOT EXISTS (
              SELECT 1
              FROM Paper_Author pa
              JOIN Registration r ON pa.User_ID = r.User_ID
              WHERE pa.Paper_ID = p.Paper_ID
                AND r.Conference_ID = p_conference_id
          )
    ) LOOP
        -- Step 3: Send reminders to each author of the paper
        FOR author_rec IN (
            SELECT u.User_ID, u.Name AS User_Name
            FROM Users u
            JOIN Paper_Author pa ON u.User_ID = pa.User_ID
            WHERE pa.Paper_ID = paper_rec.Paper_ID
        ) LOOP
            -- Increment the maximum Message_ID
            v_max_message_id := v_max_message_id + 1;

            -- Insert a reminder message for the author
            INSERT INTO Message (
                Message_ID,
                User_ID,
                Message_Time,
                Message_Body
            ) VALUES (
                v_max_message_id,
                author_rec.User_ID,
                SYSDATE,
                'Dear ' || author_rec.User_Name || 
                ', your paper "' || paper_rec.Paper_Title || 
                '" has been accepted to Conference "' || 
                v_conf_title || 
                '". Please register by ' || TO_CHAR(v_early_reg_date, 'YYYY-MM-DD') || '.'
            );

            -- Output a confirmation message
            DBMS_OUTPUT.PUT_LINE('Reminder sent to ' || author_rec.User_Name || ' for paper ID ' || paper_rec.Paper_ID);
        END LOOP;
    END LOOP;
END;
/

set serveroutput on;
BEGIN
    send_registration_reminder(1);
END;
/
select * from message;

--feature 12:
CREATE OR REPLACE PROCEDURE add_similar_paper_to_session(
    p_session_id IN NUMBER,
    p_topic_ids  IN SYS.ODCINUMBERLIST
) AS
    v_conf_id        NUMBER;
    v_max_similarity NUMBER := 0;
    v_best_paper_id  NUMBER := 0;
    v_union_size     NUMBER;
    v_intersection_size NUMBER;
BEGIN
    -- Step 1: Validate the session ID
    BEGIN
        SELECT Conference_ID
        INTO v_conf_id
        FROM Conference_Session
        WHERE Session_ID = p_session_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid session ID: ' || p_session_id);
            RETURN;
    END;

    -- Step 2: Retrieve unassigned accepted papers for the conference
    FOR paper_rec IN (
        SELECT Paper_ID
        FROM Paper
        WHERE Conference_ID = v_conf_id
          AND Status = 'accepted'
          AND Session_ID IS NULL
    ) LOOP
        -- Initialize union size with the size of input topic list
        v_union_size := p_topic_ids.COUNT;
        v_intersection_size := 0;

        -- Step 4: Calculate similarity score
        FOR paper_topic_rec IN (
            SELECT Topic_ID
            FROM Paper_Topic
            WHERE Paper_ID = paper_rec.Paper_ID
        ) LOOP
            IF p_topic_ids.EXISTS(paper_topic_rec.Topic_ID) THEN
                v_intersection_size := v_intersection_size + 1;
            ELSE
                v_union_size := v_union_size + 1;
            END IF;
        END LOOP;

        -- Compute similarity as intersection size divided by union size
        IF v_union_size > 0 THEN
            DECLARE
                v_similarity NUMBER := v_intersection_size / v_union_size;
            BEGIN
                DBMS_OUTPUT.PUT_LINE('Paper ID: ' || paper_rec.Paper_ID || ' Similarity: ' || v_similarity);
                IF v_similarity > v_max_similarity THEN
                    v_max_similarity := v_similarity;
                    v_best_paper_id := paper_rec.Paper_ID;
                END IF;
            END;
        END IF;
    END LOOP;

    -- Step 6: Assign the best paper to the session
    IF v_best_paper_id > 0 THEN
        UPDATE Paper
        SET Session_ID = p_session_id
        WHERE Paper_ID = v_best_paper_id;
        DBMS_OUTPUT.PUT_LINE('Assigned Paper ID ' || v_best_paper_id || ' to Session ID ' || p_session_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No suitable paper found to assign to Session ID ' || p_session_id);
    END IF;
END;
/
SET SERVEROUTPUT ON;
DECLARE
    v_topic_ids SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST(1, 2);
BEGIN
    add_similar_paper_to_session(1, v_topic_ids);

    DBMS_OUTPUT.PUT_LINE('Execution of add_similar_paper_to_session is complete.');
END;
/


--feature 13:
CREATE OR REPLACE PROCEDURE print_statistics AS
BEGIN
    -- 1. Acceptance rate for each conference
    FOR conf_rec IN (
        SELECT
            c.Title AS Conference_Title,
            ROUND(
                (COUNT(CASE WHEN p.Status = 'accepted' THEN 1 END) / NULLIF(COUNT(*), 0)) * 100,
                2
            ) AS Acceptance_Rate
        FROM
            Conference c
            JOIN Paper p ON c.Conference_ID = p.Conference_ID
        GROUP BY
            c.Title
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Conference: ' || conf_rec.Conference_Title || ' - Acceptance Rate: ' || conf_rec.Acceptance_Rate || '%');
    END LOOP;

    -- 2. Number of papers submitted and number of users registered for each conference
    FOR conf_stats_rec IN (
        SELECT
            c.Title AS Conference_Title,
            COUNT(DISTINCT CASE WHEN p.Status = 'submitted' THEN p.Paper_ID END) AS Submitted_Papers,
            COUNT(DISTINCT r.User_ID) AS Registered_Users
        FROM
            Conference c
            LEFT JOIN Paper p ON c.Conference_ID = p.Conference_ID
            LEFT JOIN Registration r ON c.Conference_ID = r.Conference_ID
        GROUP BY
            c.Title
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Conference: ' || conf_stats_rec.Conference_Title ||
                             ' - Submitted Papers: ' || conf_stats_rec.Submitted_Papers ||
                             ', Registered Users: ' || conf_stats_rec.Registered_Users);
    END LOOP;

    -- 3. Number of papers submitted and accepted per topic for each conference, and acceptance rate per topic
    FOR topic_stats_rec IN (
        SELECT
            c.Title AS Conference_Title,
            t.Topic_Name,
            COUNT(pt.Paper_ID) AS Submitted_Papers,
            COUNT(CASE WHEN p.Status = 'accepted' THEN pt.Paper_ID END) AS Accepted_Papers,
            ROUND(
                (COUNT(CASE WHEN p.Status = 'accepted' THEN pt.Paper_ID END) / NULLIF(COUNT(pt.Paper_ID), 0)) * 100,
                2
            ) AS Acceptance_Rate
        FROM
            Conference c
            JOIN Paper p ON c.Conference_ID = p.Conference_ID
            JOIN Paper_Topic pt ON p.Paper_ID = pt.Paper_ID
            JOIN Topic t ON pt.Topic_ID = t.Topic_ID
        GROUP BY
            c.Title,
            t.Topic_Name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Conference: ' || topic_stats_rec.Conference_Title ||
                             ', Topic: ' || topic_stats_rec.Topic_Name ||
                             ' - Submitted Papers: ' || topic_stats_rec.Submitted_Papers ||
                             ', Accepted Papers: ' || topic_stats_rec.Accepted_Papers ||
                             ', Acceptance Rate: ' || topic_stats_rec.Acceptance_Rate || '%');
    END LOOP;

    -- 4. Number of completed and not completed reviews per user
    FOR user_review_rec IN (
        SELECT
            u.Name AS User_Name,
            COUNT(CASE WHEN r.Review_Score IS NOT NULL AND r.Comments IS NOT NULL THEN 1 END) AS Completed_Reviews,
            COUNT(CASE WHEN r.Review_Score IS NULL OR r.Comments IS NULL THEN 1 END) AS Not_Completed_Reviews
        FROM
            Users u
            LEFT JOIN Review r ON u.User_ID = r.User_ID
        GROUP BY
            u.Name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('User: ' || user_review_rec.User_Name ||
                             ' - Completed Reviews: ' || user_review_rec.Completed_Reviews ||
                             ', Not Completed Reviews: ' || user_review_rec.Not_Completed_Reviews);
    END LOOP;
END;
/

BEGIN
    print_statistics;
END;
/