#pragma once

class Time
{
private:

    unsigned int m_hour;
    unsigned int m_minute;
    unsigned int m_second;

public:

    static unsigned int s_createdObjects;
    static unsigned int s_liveObjects;

    Time(const unsigned int hour, const unsigned int minute, const unsigned int second);

    ~Time();

    static void InfoAboutObjects();
    static void ShowCurrentTime();

    void Show();
};