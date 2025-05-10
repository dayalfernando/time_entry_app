import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  Platform,
} from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RouteProp } from '@react-navigation/native';
import { RootStackParamList } from '../navigation/AppNavigator';
import DateTimePicker from '@react-native-community/datetimepicker';

type Props = {
  navigation: NativeStackNavigationProp<RootStackParamList, 'TimeEntry'>;
  route: RouteProp<RootStackParamList, 'TimeEntry'>;
};

// Mock client data
const mockClients = [
  { id: '1', name: 'Client A' },
  { id: '2', name: 'Client B' },
];

export default function TimeEntryScreen({ navigation, route }: Props) {
  const [client, setClient] = useState('');
  const [date, setDate] = useState(new Date());
  const [startTime, setStartTime] = useState(new Date());
  const [endTime, setEndTime] = useState(new Date());
  const [breakTime, setBreakTime] = useState('00:00');
  const [travelTime, setTravelTime] = useState('00:00');
  const [comments, setComments] = useState('');
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [showStartTimePicker, setShowStartTimePicker] = useState(false);
  const [showEndTimePicker, setShowEndTimePicker] = useState(false);

  const handleSave = () => {
    // TODO: Implement save logic
    const timeEntry = {
      id: Date.now().toString(),
      taskId: route.params.taskId,
      clientId: client,
      date,
      startTime,
      endTime,
      breakDuration: parseTimeToMinutes(breakTime),
      travelDuration: parseTimeToMinutes(travelTime),
      comments,
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    navigation.goBack();
  };

  const handleReset = () => {
    setClient('');
    setDate(new Date());
    setStartTime(new Date());
    setEndTime(new Date());
    setBreakTime('00:00');
    setTravelTime('00:00');
    setComments('');
  };

  const parseTimeToMinutes = (time: string): number => {
    const [hours, minutes] = time.split(':').map(Number);
    return (hours * 60) + minutes;
  };

  const formatDate = (date: Date): string => {
    return date.toLocaleDateString('en-GB', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    });
  };

  const formatTime = (date: Date): string => {
    return date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true,
    });
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.content}>
        <View style={styles.field}>
          <Text style={styles.label}>Client</Text>
          <TextInput
            style={styles.input}
            value={client}
            onChangeText={setClient}
            placeholder="Search"
            placeholderTextColor="#999"
          />
          <Text style={styles.helperText}>Client Name</Text>
        </View>

        <View style={styles.field}>
          <Text style={styles.label}>Date</Text>
          <TouchableOpacity
            style={styles.input}
            onPress={() => setShowDatePicker(true)}
          >
            <Text>{formatDate(date)}</Text>
          </TouchableOpacity>
          <Text style={styles.helperText}>Working Date</Text>
        </View>

        <View style={styles.field}>
          <Text style={styles.label}>Start</Text>
          <TouchableOpacity
            style={styles.input}
            onPress={() => setShowStartTimePicker(true)}
          >
            <Text>{formatTime(startTime)}</Text>
          </TouchableOpacity>
          <Text style={styles.helperText}>Work Started Time</Text>
        </View>

        <View style={styles.field}>
          <Text style={styles.label}>Finish</Text>
          <TouchableOpacity
            style={styles.input}
            onPress={() => setShowEndTimePicker(true)}
          >
            <Text>{formatTime(endTime)}</Text>
          </TouchableOpacity>
          <Text style={styles.helperText}>Work Ended Time</Text>
        </View>

        <View style={styles.field}>
          <Text style={styles.label}>Break</Text>
          <TextInput
            style={styles.input}
            value={breakTime}
            onChangeText={setBreakTime}
            placeholder="00:00"
            placeholderTextColor="#999"
          />
          <Text style={styles.helperText}>Time Taken as Break</Text>
        </View>

        <View style={styles.field}>
          <Text style={styles.label}>Travel</Text>
          <TextInput
            style={styles.input}
            value={travelTime}
            onChangeText={setTravelTime}
            placeholder="00:00"
            placeholderTextColor="#999"
          />
          <Text style={styles.helperText}>Time Taken for Travelling</Text>
        </View>

        <View style={styles.field}>
          <Text style={styles.label}>Comment</Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={comments}
            onChangeText={setComments}
            placeholder="Enter your comments"
            placeholderTextColor="#999"
            multiline
            numberOfLines={4}
          />
          <Text style={styles.helperText}>Job Description</Text>
        </View>

        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={[styles.button, styles.resetButton]}
            onPress={handleReset}
          >
            <Text style={styles.resetButtonText}>Reset</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.button, styles.saveButton]}
            onPress={handleSave}
          >
            <Text style={styles.saveButtonText}>Save</Text>
          </TouchableOpacity>
        </View>
      </View>

      {showDatePicker && (
        <DateTimePicker
          value={date}
          mode="date"
          display="default"
          onChange={(event, selectedDate) => {
            setShowDatePicker(false);
            if (selectedDate) {
              setDate(selectedDate);
            }
          }}
        />
      )}

      {showStartTimePicker && (
        <DateTimePicker
          value={startTime}
          mode="time"
          display="default"
          onChange={(event, selectedDate) => {
            setShowStartTimePicker(false);
            if (selectedDate) {
              setStartTime(selectedDate);
            }
          }}
        />
      )}

      {showEndTimePicker && (
        <DateTimePicker
          value={endTime}
          mode="time"
          display="default"
          onChange={(event, selectedDate) => {
            setShowEndTimePicker(false);
            if (selectedDate) {
              setEndTime(selectedDate);
            }
          }}
        />
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFF9E5',
  },
  content: {
    padding: 20,
  },
  field: {
    marginBottom: 20,
  },
  label: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 5,
    color: '#000',
  },
  input: {
    backgroundColor: '#fff',
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    color: '#000',
  },
  textArea: {
    height: 100,
    textAlignVertical: 'top',
  },
  helperText: {
    fontSize: 14,
    color: '#666',
    marginTop: 5,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 20,
  },
  button: {
    flex: 1,
    padding: 15,
    borderRadius: 8,
    alignItems: 'center',
    marginHorizontal: 5,
  },
  resetButton: {
    backgroundColor: '#D9D9D9',
  },
  saveButton: {
    backgroundColor: '#E8C872',
  },
  resetButtonText: {
    color: '#000',
    fontSize: 16,
    fontWeight: 'bold',
  },
  saveButtonText: {
    color: '#000',
    fontSize: 16,
    fontWeight: 'bold',
  },
}); 