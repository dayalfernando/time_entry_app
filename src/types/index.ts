export interface Client {
  id: string;
  name: string;
}

export interface Task {
  id: string;
  title: string;
  description?: string;
  clientId: string;
  status: 'pending' | 'in-progress' | 'completed';
  createdAt: Date;
  updatedAt: Date;
}

export interface TimeEntry {
  id: string;
  taskId: string;
  clientId: string;
  date: Date;
  startTime: Date;
  endTime: Date;
  breakDuration: number; // in minutes
  travelDuration: number; // in minutes
  comments: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Category {
  id: string;
  name: string;
  color: string;
} 