import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RouteProp } from '@react-navigation/native';
import { RootStackParamList } from '../navigation/AppNavigator';
import { Task, TimeEntry } from '../types';

type Props = {
  navigation: NativeStackNavigationProp<RootStackParamList, 'TaskDetail'>;
  route: RouteProp<RootStackParamList, 'TaskDetail'>;
};

// Mock data
const mockTask: Task = {
  id: '1',
  title: 'Generator Installation',
  description: 'Install new generator at Site A',
  status: 'in-progress',
  duration: 120,
  createdAt: new Date(),
  updatedAt: new Date(),
};

const mockTimeEntries: TimeEntry[] = [
  {
    id: '1',
    taskId: '1',
    startTime: new Date(2024, 4, 8, 9, 0),
    endTime: new Date(2024, 4, 8, 11, 0),
    duration: 120,
    notes: 'Initial setup and configuration',
    createdAt: new Date(),
  },
];

export default function TaskDetailScreen({ navigation, route }: Props) {
  const [task] = useState<Task>(mockTask);
  const [timeEntries] = useState<TimeEntry[]>(mockTimeEntries);
  const [isTracking, setIsTracking] = useState(false);

  const handleStartTracking = () => {
    setIsTracking(true);
    navigation.navigate('TimeEntry', { taskId: task.id });
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.section}>
        <Text style={styles.title}>{task.title}</Text>
        <Text style={styles.description}>{task.description}</Text>
        <View style={styles.statusContainer}>
          <Text style={styles.label}>Status:</Text>
          <Text style={styles.status}>{task.status}</Text>
        </View>
        <View style={styles.durationContainer}>
          <Text style={styles.label}>Total Duration:</Text>
          <Text style={styles.duration}>{task.duration} minutes</Text>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Time Entries</Text>
        {timeEntries.map((entry) => (
          <View key={entry.id} style={styles.timeEntry}>
            <Text style={styles.timeEntryTime}>
              {entry.startTime.toLocaleTimeString()} - {entry.endTime?.toLocaleTimeString()}
            </Text>
            <Text style={styles.timeEntryDuration}>{entry.duration} minutes</Text>
            {entry.notes && <Text style={styles.timeEntryNotes}>{entry.notes}</Text>}
          </View>
        ))}
      </View>

      <TouchableOpacity
        style={[styles.trackButton, isTracking && styles.trackingButton]}
        onPress={handleStartTracking}
        disabled={isTracking}
      >
        <Text style={styles.trackButtonText}>
          {isTracking ? 'Tracking in Progress...' : 'Start Time Tracking'}
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  section: {
    padding: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  description: {
    fontSize: 16,
    color: '#666',
    marginBottom: 15,
  },
  statusContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  durationContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    marginRight: 10,
  },
  status: {
    fontSize: 16,
    color: '#444',
  },
  duration: {
    fontSize: 16,
    color: '#444',
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  timeEntry: {
    backgroundColor: '#f8f8f8',
    padding: 15,
    borderRadius: 8,
    marginBottom: 10,
  },
  timeEntryTime: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 5,
  },
  timeEntryDuration: {
    fontSize: 14,
    color: '#666',
    marginBottom: 5,
  },
  timeEntryNotes: {
    fontSize: 14,
    color: '#888',
  },
  trackButton: {
    backgroundColor: '#f4511e',
    padding: 15,
    borderRadius: 8,
    margin: 20,
    alignItems: 'center',
  },
  trackingButton: {
    backgroundColor: '#888',
  },
  trackButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});