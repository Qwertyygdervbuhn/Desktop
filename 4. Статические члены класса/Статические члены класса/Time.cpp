#include "Time.h"

#include <ctime>
#include <iostream>

using namespace std;

unsigned int Time::s_createdObjects = 0U;
unsigned int Time::s_liveObjects = 0U;

Time::Time(const unsigned int hour, const unsigned int minute, const unsigned int second) :
    m_hour(hour),
    m_minute(minute),
    m_second(second)
{
    ++s_createdObjects;
    ++s_liveObjects;
}

Time::~Time()
{
    --s_liveObjects;
}

void Time::InfoAboutObjects()
{
    cout << "Created objects: " << s_createdObjects << endl;
    cout << "Live objects: " << s_liveObjects << endl;
}

void Time::Show()
{
    cout << m_hour << ":" << m_minute << ":" << m_second << endl;
}

void Time::ShowCurrentTime()
{
    char date[50] = {};

    time_t unixTime = time(nullptr);

    ctime_s(date, sizeof(date) / sizeof(date[0]), &unixTime);

    cout << date << endl;
}