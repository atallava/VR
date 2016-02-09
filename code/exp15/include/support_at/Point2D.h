#pragma once
#include <iostream>

namespace support_at {
    class Point2D_d {
    public:
	Point2D_d();
	Point2D_d(double x, double y);
	inline double x() const { return m_x; }
	inline double y() const { return m_y; }
	inline double& x() { return m_x; }
	inline double& y() { return m_y; }
	double m_x;
	double m_y;
    };
    static std::ostream& operator<<(std::ostream& os,
				    const Point2D_d& pt)
    {
	os << "x: " << pt.m_x << ", y: " << pt.m_y;
	return os;
    }
}
