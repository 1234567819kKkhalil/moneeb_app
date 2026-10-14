part of zad;

class EventsState extends Equatable {
  final StateBox<List<EventModel>> events;

  const EventsState({
    required this.events,
  });

  factory EventsState.initial() => const EventsState(
        events: StateBox.initial(),
      );

  EventsState reduce({
    StateBox<List<EventModel>>? events,
  }) {
    return EventsState(
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [events];
}
