/**
 * @file passenger_unloader.h
 *
 * @copyright 2019 3081 Staff, All rights reserved.
 */

#ifndef SRC_PASSENGER_UNLOADER_H_
#define SRC_PASSENGER_UNLOADER_H_
#include <list>
#include "src/passenger.h"
#include "src/stop.h"
class Stop;
class Passenger;

class PassengerUnloader {
 public:
  // UnloadPassengers returns the number of passengers removed from the bus.
  int UnloadPassengers(std::list<Passenger*>& passengers, Stop * current_stop);
};
#endif  // SRC_PASSENGER_UNLOADER_H_


