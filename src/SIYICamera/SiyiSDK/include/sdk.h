#pragma once

#include <QUdpSocket>
#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkReply>

#include <FactGroup.h>
#include "Vehicle.h"

#include <thread>
#include <ctime>

#include "message.h"

class SIYI_SDK : public FactGroup {
    Q_OBJECT

public:
    SIYI_SDK(int updateRateMsecs, const QString& metaDataFile, QObject* parent = nullptr, bool ignoreCamelCase = false);
    virtual ~SIYI_SDK();
    void print_message() const;

    struct FirmwareVersionMsg {
        int seq = 0;
        uint32_t code_board_version;
        uint32_t gimbal_firmware_version;
        uint32_t zoom_firmware_version;
    };

    struct HardwareIDMsg {
        int seq = 0;
        uint8_t id;
    };

    struct AutofocusMsg {
        int seq = 0;
        bool success = false;
    };

    struct ManualZoomMsg {
        int seq = 0;
        float zoom_level = -1;
    };

    struct AbsoluteZoomMsg {
        int seq = 0;
        bool success = false;
    };

    struct MaxZoomMsg {
        int seq = 0;
        float max_level = 0.0;
    };

    struct ManualFocusMsg {
        int seq = 0;
        bool success = false;
    };

    struct GimbalSpeedMsg {
        int seq = 0;
        bool success = false;
    };

    struct CenterMsg {
        int seq = 0;
        bool success = false;
    };

    struct RecordingStateMsg {
        int seq = 0;
        int state = -1;
    };

    struct MountingDirectionMsg {
        int seq = 0;
        int direction = -1;
    };

    struct MotionModeMsg {
        int seq = 0;
        int mode = -1;
    };

    struct FunctionFeedbackMsg {
        int seq = 0;
        int info_type = -1;
    };

    struct GimbalAttitudeMsg {
        int seq = 0;
        float yaw = 0.0;
        float pitch = 0.0;
        float roll = 0.0;
        float yaw_speed = 0.0;
        float pitch_speed = 0.0;
        float roll_speed = 0.0;
    };

    struct GimbalAnglesMsg {
        int seq = 0;
        float yaw = 0.0;
        float pitch = 0.0;
        float roll = 0.0;
    };

    /////////////////////////////////
    //  REQUEST AND SET FUNCTIONS  //
    /////////////////////////////////

    bool request_firmware_version();

    bool request_hardware_id();

    bool request_autofocus();

    bool request_zoom_in();

    bool request_zoom_out();

    bool request_zoom_halt();

    bool set_absolute_zoom(int integer, int fractional);

    bool request_maximum_zoom();

    bool request_focus_far();

    bool request_focus_close();

    bool request_focus_halt();

    bool set_gimbal_speed(int yaw_speed, int pitch_speed);

    bool request_gimbal_center();

    bool request_gimbal_info();

    bool request_lock_mode();

    bool request_follow_mode();

    bool request_fpv_mode();

    bool request_function_feedback();

    bool request_photo();

    bool request_record();

    bool request_gimbal_attitude();

    bool set_gimbal_angles(float yaw, float pitch);


    ///////////////////////
    //  PARSE FUNCTIONS  //
    ///////////////////////

    void parse_firmware_version_msg();

    void parse_hardware_id_msg();

    void parse_autofocus_msg();

    void parse_manual_zoom_msg();

    void parse_absolute_zoom_msg();

    void parse_maximum_zoom_msg();

    void parse_manual_focus_msg();

    void parse_gimbal_speed_msg();

    void parse_gimbal_center_msg();

    void parse_gimbal_info_msg();

    void parse_function_feedback_msg();

    void parse_gimbal_attitude_msg();

    void parse_gimbal_angles_msg();

    /////////////////////
    //  GET FUNCTIONS  //
    /////////////////////

    [[nodiscard]] std::tuple<uint32_t, uint32_t, uint32_t> get_firmware_version() const;

    [[nodiscard]] uint8_t get_hardware_id() const;

    [[nodiscard]] float get_zoom_level() const;

    [[nodiscard]] float get_maximum_zoom() const;

    [[nodiscard]] int get_recording_state() const;

    [[nodiscard]] int get_motion_mode() const;

    [[nodiscard]] int get_mounting_direction() const;

    [[nodiscard]] int get_function_feedback() const;

    [[nodiscard]] std::tuple<float, float, float> get_gimbal_attitude() const;

    [[nodiscard]] std::tuple<float, float, float> get_gimbal_attitude_speed() const;

// public slots:
//     virtual bool send_message(const uint8_t *message, const int length) const = 0;

signals:
    void send_message_signal(const uint8_t *message, const int length);

protected:
    void print_size_err(uint8_t) const;
    virtual bool send_message(const uint8_t *message, const int length) const = 0;

    FirmwareVersionMsg firmware_version_msg;
    HardwareIDMsg hardware_id_msg;
    AutofocusMsg autofocus_msg;
    ManualZoomMsg manual_zoom_msg;
    MaxZoomMsg max_zoom_msg;
    AbsoluteZoomMsg absoluteZoom_msg;
    ManualFocusMsg manual_focus_msg;
    GimbalSpeedMsg gimbal_speed_msg;
    CenterMsg gimbal_center_msg;
    RecordingStateMsg recording_state_msg;
    MountingDirectionMsg mounting_direction_msg;
    MotionModeMsg motion_mode_msg;
    FunctionFeedbackMsg function_feedback_msg;
    GimbalAttitudeMsg gimbal_att_msg;
    GimbalAnglesMsg gimbal_angles_msg;

    const int MINIMUM_DATA_LENGTH = 10;
    uint8_t m_msg_buffer[74];
    SIYI_Message msg;

    // HTTP constants
    const QString _httpServerPrefix =               QString("http://");
    const QString _httpServerPort =                 QString("82");
    const QString _httpServerSuffix =               QString("/cgi-bin/media.cgi");
    const QString _httpServerGetDirectoriseSuffix = QString("/api/v1/getdirectories");
    const QString _httpServerGetMediaCountSuffix =  QString("/api/v1/getmediacount");
    const QString _httpServerGetMediaListSuffix =   QString("/api/v1/getmedialist");
    const QString _httpMediaImageParam =            QString("?media_type=0");
    const QString _httpMediaVideoParam =            QString("?media_type=1");
    const QString _httpTempImageFolderPath =        QString("&path=101SIYI_IMG"); // TODO fix using getDirectoriesRequest
};

class SIYIUnixCamera : public SIYI_SDK {
    Q_OBJECT

public:
    SIYIUnixCamera();
    virtual ~SIYIUnixCamera() override;
    static const char* getIpFromSettings();
    static int getPortFromSettings();

    Q_PROPERTY(Fact* absoluteRoll               READ absoluteRoll               CONSTANT)
    Q_PROPERTY(Fact* absolutePitch              READ absolutePitch              CONSTANT)
    Q_PROPERTY(Fact* bodyYaw                    READ bodyYaw                    CONSTANT)
    Q_PROPERTY(Fact* absoluteYaw                READ absoluteYaw                CONSTANT)
    Q_PROPERTY(bool  yawLock                    READ yawLock                    NOTIFY yawLockChanged)
    Q_PROPERTY(Fact* amountOfImages             READ amountOfImages             CONSTANT)

    Fact* absoluteRoll()                  { return &_absoluteRollFact;  }
    Fact* absolutePitch()                 { return &_absolutePitchFact; }
    Fact* bodyYaw()                       { return &_bodyYawFact;       }
    Fact* absoluteYaw()                   { return &_absoluteYawFact;   }
    bool  yawLock() const                 { return _yawLock;            }
    Fact* amountOfImages()                { return &_amountOfImagesFact;}
    Vehicle* active_vehicle()             { return _active_vehicle;     }

    void  setAbsoluteRoll(float absoluteRoll)   { _absoluteRollFact.setRawValue(absoluteRoll);                     }
    void  setAbsolutePitch(float absolutePitch) { _absolutePitchFact.setRawValue(absolutePitch);                   }
    void  setBodyYaw(float bodyYaw)             { _bodyYawFact.setRawValue(bodyYaw);                               }
    void  setAbsoluteYaw(float absoluteYaw)     { _absoluteYawFact.setRawValue(absoluteYaw);                       }
    void  setYawLock(bool yawLock)              { _yawLock = yawLock;       emit yawLockChanged();                 }

public slots:
    void settingsChanged();
    void receive_message();
    void send_message_slot(const uint8_t *message, const int length);
    void send_http_request_slot(QString url);
    void checkConnection();
    void activeVehicleChanged(Vehicle* activeVehicle);
    void httpReplyImageAmountFinished(QNetworkReply* reply);

signals:
    void send_message_signal(const uint8_t *message, const int length);
    void send_http_request_signal(QString url);
    void http_reply_ready_image_amount_signal(QNetworkReply* reply);
    void yawLockChanged();

private:
    virtual bool send_message(const uint8_t *message, const int length) const override;
    void gimbal_attitude_loop(bool &connected);
    void gimbal_info_loop(bool &connected);
    void camera_count_images_loop(bool &connected);
    bool request_gimbal_attitude();
    bool request_firmware_version();
    bool request_gimbal_info();
    void parse_attitude_msg_to_facts();
    QString getHttpURLBase(){ return _httpServerPrefix + camera_ip + QString(":") + _httpServerPort + QString("/") + _httpServerSuffix; }


    bool live = false;
    bool turnedOn = false;
    std::thread gimbal_attitude_thread;
    std::thread gimbal_info_thread;
    std::thread http_image_count_thread;
    QUdpSocket* socket_out;
    QNetworkAccessManager* httpNetworkManager;
    QString camera_ip;
    quint16 camera_port;
    time_t lastSuccResponse = 0;
    time_t preLastSuccResponse = 0;
    Vehicle* _active_vehicle = nullptr;

    // Q_PROPERTIES
    Fact _absoluteRollFact;
    Fact _absolutePitchFact;
    Fact _bodyYawFact;
    Fact _absoluteYawFact;
    Fact _amountOfImagesFact;
    bool _yawLock = false;

    // Fact names
    static const char* _absoluteRollFactName;
    static const char* _absolutePitchFactName;
    static const char* _bodyYawFactName;
    static const char* _absoluteYawFactName;
    static const char* _amountOfImagesFactName;
};
