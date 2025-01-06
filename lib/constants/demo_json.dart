import 'dart:convert';

List<Map<String, dynamic>> demoPatientsJson = [
  {
    'patient_id': 'eb001',
    '_id': '994f9838-09a0-4c0a-9837-104a83f069c7',
    '_name': {'firstName': 'Emily', 'lastName': 'Brown'},
    '_email': 'em@em.com',
    '_dateOfBirth': '1945-02-20',
    'sex_at_birth': 1,
    'current_sex': 1,
    'race': 4,
    'ethnicity': 1,
    'condition': {
      '_id': 'eaf73483-92ff-4848-814e-7964976c42e1',
      'condition_type': ['orthotic', 'lower'],
    },
    'k_level': {
      '_id': 'ebaab449-e9b3-44ee-9c48-82a7c26ffe1d',
      'k_level': 0,
    },
    'encounters': [
      {
        '_name': 'be_session_20240602_14:49:05',
        '_id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
        'promispi_smartpo': {
          'id': '41e27e63-28de-49e6-8a6e-76d345c21f34',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'promispi_score': 42.0,
          'promispi_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'promispi_order': 1,
          'promispi_created_time': '2024-06-02T14:48:03.794748',
          'promispi_raw_data': jsonEncode({".": "."}),
        },
        'psfs_smartpo': {
          'id': '9a55831d-23d1-436d-a923-4cfcfec7170c',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'psfs_score': 6.0,
          'psfs_created_time': '2024-06-02T14:48:03.793899',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psfs_raw_data': jsonEncode({".": "."}),
        },
        'total_score_smartpo': 63.407407407407405,
        'condition_smartpo': {
          'id': 'eaf73483-92ff-4848-814e-7964976c42e1',
        },
        'domain_scores_smartpo': {
          'id': 'd59d711a-70e6-4a9c-8a76-59f7ebb6540f',
        },
        'tug_smartpo': {
          'id': 'e37403e4-a56a-41f0-83da-e12e36ee0ed8',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'tug_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'tug_raw_data': jsonEncode({".": "."}),
          'tug_elapsed_time': 13.0,
          'tug_created_time': '2024-06-02T14:48:03.795109',
          'tug_order': 2,
        },
        'domain_weight_distribution_smartpo': {
          'id': '29c495ba-1106-4060-a111-340628f65e71',
          'hrqol_weight_val': 13.898957305673504,
          'function_weight_val': 16.62424305188399,
          'goals_weight_val': 5.505077207345191,
          'comfort_weight_val': 53.34310802487641,
          'satisfaction_weight_val': 10.628614410220912,
        },
        'fh_smartpo': {
          'id': '261a46e9-9b53-4597-8a77-107865636932',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'fh_raw_data': jsonEncode({".": "."}),
          'falls_per_week': 2.0,
          'fh_created_time': '2024-06-02T14:48:03.795869',
          'fh_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'fh_order': 4,
        },
        'tmwt_smartpo': {
          'id': 'bfc4f5d5-4dc1-4ff9-ab07-0855411d37c1',
          '_referencers': {
            'tmwt_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'tmwt_raw_data': jsonEncode({".": "."}),
          'tmwt_order': 3,
          'tmwt_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'comfortable_speed': 1.0,
          'tmwt_created_time': '2024-06-02T14:48:03.795651',
          'maximum_speed': 28.85,
        },
        'eq5d_5l_smartpo': {
          'id': '7c277f15-5cd6-4c98-be69-42218ccd59cb',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'eq5d_5l_raw_data': jsonEncode({".": "."}),
          'eq5d_5l_health_score': 52.0,
          'eq5d_5l_created_time': '2024-06-02T14:48:03.796765',
          'eq5d_5l_order': 6,
        },
        'k_level_smartpo': {
          'id': 'ebaab449-e9b3-44ee-9c48-82a7c26ffe1d',
        },
        'encounter_created_time_smartpo': '2024-06-02T14:49:05.984258',
        'outcome_measures': 'psfs, promispi, tug, tmwt, fh, psq, eq5d_5l',
        'psq_smartpo': {
          'id': '36089c71-9d49-4d7d-a9de-f9400012369a',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'adfc6fd9-bab0-4ea4-b7e0-407e0ee967d6',
              }
            }
          },
          'psq_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psq_raw_data': jsonEncode({".": "."}),
          'psq_score': 74.0,
          'psq_order': 5,
          'psq_created_time': '2024-06-02T14:48:03.796448',
        },
      },
      {
        '_name': 'be_session_20240410_14:46:42',
        '_id': 'b6cf03da-60a4-42c0-b690-59782145639b',
        'promispi_smartpo': {
          'id': 'ae24ff0a-3a92-418f-a211-c0f0a10fc4f1',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'promispi_score': 55.0,
          'promispi_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'promispi_order': 1,
          'promispi_created_time': '2024-04-10T14:45:25.825950',
          'promispi_raw_data': jsonEncode({".": "."}),
        },
        'psfs_smartpo': {
          'id': 'a42af812-3074-46a1-9002-f43c11c153f4',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'psfs_score': 8.0,
          'psfs_created_time': '2024-04-10T14:45:25.825631',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psfs_raw_data': jsonEncode({".": "."}),
        },
        'total_score_smartpo': 62.50370370370369,
        'condition_smartpo': {
          'id': 'eaf73483-92ff-4848-814e-7964976c42e1',
        },
        'domain_scores_smartpo': {
          'id': 'da1615ff-0c23-46eb-8917-7b96cb9face3',
        },
        'tug_smartpo': {
          'id': '525bf31a-a348-4b77-8687-d837f885c08c',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'tug_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'tug_raw_data': jsonEncode({".": "."}),
          'tug_elapsed_time': 15.0,
          'tug_created_time': '2024-04-10T14:45:25.826152',
          'tug_order': 2,
        },
        'domain_weight_distribution_smartpo': {
          'id': '29c495ba-1106-4060-a111-340628f65e71',
          'hrqol_weight_val': 13.898957305673504,
          'function_weight_val': 16.62424305188399,
          'goals_weight_val': 5.505077207345191,
          'comfort_weight_val': 53.34310802487641,
          'satisfaction_weight_val': 10.628614410220912,
        },
        'fh_smartpo': {
          'id': 'fbab6fd4-d48c-4785-b782-057c7e8f7418',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'fh_raw_data': jsonEncode({".": "."}),
          'falls_per_week': 1.0,
          'fh_created_time': '2024-04-10T14:45:25.826482',
          'fh_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'fh_order': 4,
        },
        'tmwt_smartpo': {
          'id': '7b5fb1be-2f9c-4b39-8a84-17fb2b914b3b',
          '_referencers': {
            'tmwt_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'tmwt_raw_data': jsonEncode({".": "."}),
          'tmwt_order': 3,
          'tmwt_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'comfortable_speed': 0.7,
          'tmwt_created_time': '2024-04-10T14:45:25.826317',
          'maximum_speed': 45.45,
        },
        'eq5d_5l_smartpo': {
          'id': 'ed2dfc64-fec7-418e-a4d4-94a7fb09b6f2',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'eq5d_5l_raw_data': jsonEncode({".": "."}),
          'eq5d_5l_health_score': 38.0,
          'eq5d_5l_created_time': '2024-04-10T14:45:25.826919',
          'eq5d_5l_order': 6,
        },
        'k_level_smartpo': {
          'id': 'ebaab449-e9b3-44ee-9c48-82a7c26ffe1d',
        },
        'encounter_created_time_smartpo': '2024-04-10T14:46:42.667509',
        'outcome_measures': 'psfs, promispi, tug, tmwt, fh, psq, eq5d_5l',
        'psq_smartpo': {
          'id': '6ce9c490-79f1-46c3-b03b-3b91aae5de0f',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'b6cf03da-60a4-42c0-b690-59782145639b',
              }
            }
          },
          'psq_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psq_raw_data': jsonEncode({".": "."}),
          'psq_score': 72.0,
          'psq_order': 5,
          'psq_created_time': '2024-04-10T14:45:25.826755',
        },
      },
      {
        '_name': 'be_session_20240218_14:43:55',
        '_id': 'd506b5bd-76b7-473b-813f-017639079971',
        'promispi_smartpo': {
          'id': 'f3170f4b-220c-4a9c-9812-c0426aadf027',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'promispi_score': 55.0,
          'promispi_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'promispi_order': 1,
          'promispi_created_time': '2024-02-18T14:42:46.397641',
          'promispi_raw_data': jsonEncode({".": "."}),
        },
        'psfs_smartpo': {
          'id': '854ed68b-1671-4148-9ee6-5a2cccd56b2f',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'psfs_score': 5.0,
          'psfs_created_time': '2024-02-18T14:42:46.397281',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psfs_raw_data': jsonEncode({".": "."}),
        },
        'total_score_smartpo': 43.34074074074074,
        'condition_smartpo': {
          'id': 'eaf73483-92ff-4848-814e-7964976c42e1',
        },
        'domain_scores_smartpo': {
          'id': 'f7969aa9-06ce-493f-9d75-a327ae70ef61',
        },
        'tug_smartpo': {
          'id': 'e1f68f4a-e39f-487c-a1c1-a95eaa90d7ae',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'tug_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'tug_raw_data': jsonEncode({".": "."}),
          'tug_elapsed_time': 17.0,
          'tug_created_time': '2024-02-18T14:42:46.397822',
          'tug_order': 2,
        },
        'domain_weight_distribution_smartpo': {
          'id': '29c495ba-1106-4060-a111-340628f65e71',
          'hrqol_weight_val': 13.898957305673504,
          'function_weight_val': 16.62424305188399,
          'goals_weight_val': 5.505077207345191,
          'comfort_weight_val': 53.34310802487641,
          'satisfaction_weight_val': 10.628614410220912,
        },
        'fh_smartpo': {
          'id': '05c134ce-834c-46d2-9f55-efa8085d49b2',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'fh_raw_data': jsonEncode({".": "."}),
          'falls_per_week': 4.0,
          'fh_created_time': '2024-02-18T14:42:46.398087',
          'fh_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'fh_order': 4,
        },
        'tmwt_smartpo': {
          'id': '93801d98-7de5-434c-8920-f53828001608',
          '_referencers': {
            'tmwt_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'tmwt_raw_data': jsonEncode({".": "."}),
          'tmwt_order': 3,
          'tmwt_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'comfortable_speed': 0.5,
          'tmwt_created_time': '2024-02-18T14:42:46.397969',
          'maximum_speed': 71.01,
        },
        'eq5d_5l_smartpo': {
          'id': 'af28886a-866d-4d26-952f-b065859ff400',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'eq5d_5l_raw_data': jsonEncode({".": "."}),
          'eq5d_5l_health_score': 24.0,
          'eq5d_5l_created_time': '2024-02-18T14:42:46.398466',
          'eq5d_5l_order': 6,
        },
        'k_level_smartpo': {
          'id': 'ebaab449-e9b3-44ee-9c48-82a7c26ffe1d',
        },
        'encounter_created_time_smartpo': '2024-02-18T14:43:55.285979',
        'outcome_measures': 'psfs, promispi, tug, tmwt, fh, psq, eq5d_5l',
        'psq_smartpo': {
          'id': '46aec986-fe5d-4693-9cb7-185cdd65d035',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'd506b5bd-76b7-473b-813f-017639079971',
              }
            }
          },
          'psq_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psq_raw_data': jsonEncode({".": "."}),
          'psq_score': 75.0,
          'psq_order': 5,
          'psq_created_time': '2024-02-18T14:42:46.398321',
        },
      },
      {
        '_name': 'be_session_20231120_14:40:50',
        '_id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
        'promispi_smartpo': {
          'id': 'a7f8f584-05cd-4a29-99b2-ebf0a61f223f',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'promispi_score': 58.0,
          'promispi_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'promispi_order': 1,
          'promispi_created_time': '2023-11-20T14:39:40.014310',
          'promispi_raw_data': jsonEncode({".": "."}),
        },
        'psfs_smartpo': {
          'id': 'beb08dda-765b-4433-b962-73331ec10960',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'psfs_score': 0.0,
          'psfs_created_time': '2023-11-20T14:39:40.012671',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psfs_raw_data': jsonEncode({".": "."}),
        },
        'total_score_smartpo': 24.0,
        'condition_smartpo': {
          'id': 'eaf73483-92ff-4848-814e-7964976c42e1',
        },
        'domain_scores_smartpo': {
          'id': '6202ba5a-2808-4199-b909-b6273b04e474',
        },
        'tug_smartpo': {
          'id': '41b29d9f-803a-4494-9900-fa1a3ec888f2',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'tug_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'tug_raw_data': jsonEncode({".": "."}),
          'tug_elapsed_time': 18.0,
          'tug_created_time': '2023-11-20T14:39:40.015683',
          'tug_order': 2,
        },
        'domain_weight_distribution_smartpo': {
          'id': '29c495ba-1106-4060-a111-340628f65e71',
          'hrqol_weight_val': 13.898957305673504,
          'function_weight_val': 16.62424305188399,
          'goals_weight_val': 5.505077207345191,
          'comfort_weight_val': 53.34310802487641,
          'satisfaction_weight_val': 10.628614410220912,
        },
        'fh_smartpo': {
          'id': 'e7a646d5-0e51-4fa6-bb90-e8562834c881',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'fh_raw_data': jsonEncode({".": "."}),
          'falls_per_week': 6.0,
          'fh_created_time': '2023-11-20T14:39:40.017809',
          'fh_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'fh_order': 4,
        },
        'tmwt_smartpo': {
          'id': '8a77e35f-5951-4e50-8f0d-1453c7eb1c86',
          '_referencers': {
            'tmwt_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'tmwt_raw_data': jsonEncode({".": "."}),
          'tmwt_order': 3,
          'tmwt_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'comfortable_speed': 0.4,
          'tmwt_created_time': '2023-11-20T14:39:40.017025',
          'maximum_speed': 27.65,
        },
        'eq5d_5l_smartpo': {
          'id': 'b30ebc7d-beb6-4590-b616-1a9782a5c275',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'eq5d_5l_raw_data': jsonEncode({".": "."}),
          'eq5d_5l_health_score': 16.0,
          'eq5d_5l_created_time': '2023-11-20T14:39:40.021136',
          'eq5d_5l_order': 6,
        },
        'k_level_smartpo': {
          'id': 'ebaab449-e9b3-44ee-9c48-82a7c26ffe1d',
        },
        'encounter_created_time_smartpo': '2023-11-20T14:40:50.041293',
        'outcome_measures': 'psfs, promispi, tug, tmwt, fh, psq, eq5d_5l',
        'psq_smartpo': {
          'id': '340e9c06-efa6-443b-9fb6-f8717cf176bb',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '57cf3e6c-310d-4c34-b88e-ef2a9e5458a6',
              }
            }
          },
          'psq_patient': {
            'id': '994f9838-09a0-4c0a-9837-104a83f069c7',
          },
          'psq_raw_data': jsonEncode({".": "."}),
          'psq_score': 50.0,
          'psq_order': 5,
          'psq_created_time': '2023-11-20T14:39:40.020125',
        },
      }
    ],
    'domainScores': [
      {
        '_name': 'be_dm_scores_20240602_144909',
        'function_domain_score': 48.703703703703695,
        'comfort_domain_score': 96.41873278,
        'satisfaction_domain_score': 74.0,
        'hrqol_domain_score': 52.0,
        'goals_domain_score': 60.0,
      },
      {
        '_name': 'be_dm_scores_20240410_144646',
        'function_domain_score': 43.518518518518505,
        'comfort_domain_score': 61,
        'satisfaction_domain_score': 72.0,
        'hrqol_domain_score': 38.0,
        'goals_domain_score': 80.0,
      },
      {
        '_name': 'be_dm_scores_20240218_144359',
        'function_domain_score': 8.703703703703702,
        'comfort_domain_score': 60,
        'satisfaction_domain_score': 75.0,
        'hrqol_domain_score': 24.0,
        'goals_domain_score': 50.0,
      },
      {
        '_name': 'be_dm_scores_20231120_144054',
        'function_domain_score': 3.333333333333333,
        'comfort_domain_score': 51.66666667,
        'satisfaction_domain_score': 50.0,
        'hrqol_domain_score': 16.0,
        'goals_domain_score': 0.0,
      }
    ],
    'assistive_devices': [
      {
        '_id': '6d5daee3-52cd-4ad7-a444-d2544fd3ba5d',
        'device_name': 'test1',
        'amputee_side': 0,
        'l_code': 'L0001',
      }
    ]
  },
  {
    'patient_id': 'aj001',
    '_id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
    '_name': {'firstName': 'Alex', 'lastName': 'Johnson'},
    '_email': 'aj@aj.com',
    '_dateOfBirth': '1992-08-07',
    'sex_at_birth': 0,
    'current_sex': 0,
    'race': 2,
    'ethnicity': 1,
    'condition': {
      '_id': '7c032330-7fca-4b3a-8517-4807df157011',
      'condition_type': ['prosthetic', 'lower'],
    },
    'k_level': {
      '_id': 'd5c23653-7100-44b8-b722-d9449ee33ed7',
      'k_level': 1,
    },
    'encounters': [
      {
        '_name': 'ja_session_20240628_15:42:38',
        '_id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
        'promispi_smartpo': {
          'id': 'cb8c7d64-c423-4993-ab2e-46e93f857f83',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'promispi_score': 46.0,
          'promispi_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'promispi_order': 3,
          'promispi_created_time': '2024-06-28T15:35:10.643524',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': '37e2b1fe-df88-4920-a030-9e4c6041415c',
          '_name': 'AJ_scs_6/28/2024_14:08:49',
          '_id': '37e2b1fe-df88-4920-a030-9e4c6041415c',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2024-06-28T15:35:10.642809',
          'scs_score': 9.0,
          'scs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': 'd31acbc8-48c1-4cb0-8bc5-01461707725a',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'psfs_score': 9.0,
          'psfs_created_time': '2024-06-28T15:35:10.641855',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 72.2,
        'condition_smartpo': {
          'id': '7c032330-7fca-4b3a-8517-4807df157011',
        },
        'domain_scores_smartpo': {
          'id': 'c90ea6fe-d241-4a1d-b949-04ccc3ff2314',
        },
        'pmq_smartpo': {
          'id': 'c67fc8bd-1e29-4776-83e9-0d03056f859a',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'pmq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'pmq_score': 90.0,
          'pmq_created_time': '2024-06-28T15:35:10.644684',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '454a23c2-c990-44dc-a028-d1e4d0439567',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'tug_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 9.0,
          'tug_created_time': '2024-06-28T15:35:10.644208',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': 'a3b659bd-59ac-4b6b-a93e-39689b0ef8ac',
          'hrqol_weight_val': 16.334661354581673,
          'function_weight_val': 20.318725099601593,
          'goals_weight_val': 26.693227091633464,
          'comfort_weight_val': 4.780876494023905,
          'satisfaction_weight_val': 31.872509960159363,
          '_creationTime': '2024-06-28T22:18:05.848Z',
          '_lastModifiedTime': '2024-06-28T22:18:05.848Z',
          '_caption': 'ja_dwd_current'
        },
        'fh_smartpo': {
          'id': '26873912-7dc5-447d-b8c1-91f1744b6d91',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 0.0,
          'fh_created_time': '2024-06-28T15:35:10.644363',
          'fh_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': 'e5507252-72f3-41e6-b41a-71e93ef2d06c',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 82.0,
          'eq5d_5l_created_time': '2024-06-28T15:35:10.644955',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': 'd5c23653-7100-44b8-b722-d9449ee33ed7',
        },
        'encounter_created_time_smartpo': '2024-06-28T15:42:38.470311',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '237aee72-eb94-48f4-aef8-5c950861d27b',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'eb4a964d-6e00-4221-adde-2c4bf36210bc',
              }
            }
          },
          'psq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 20.0,
          'psq_order': 1,
          'psq_created_time': '2024-06-28T15:35:10.642529',
        },
      },
      {
        '_name': 'ja_session_20240430_15:33:13',
        '_id': '3b888927-3ec5-410e-8b8d-493c2e305583',
        'promispi_smartpo': {
          'id': 'e518c3c1-2f43-4239-a3f5-0278ba2e5981',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'promispi_score': 62.0,
          'promispi_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'promispi_order': 3,
          'promispi_created_time': '2024-04-30T15:31:35.940717',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': '7b36b616-c3fd-41b0-be70-7a473487ace8',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2024-04-30T15:31:35.939946',
          'scs_score': 8.0,
          'scs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': 'ca0b1735-cc6c-4976-83a5-e4f36979042e',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'psfs_score': 6.0,
          'psfs_created_time': '2024-04-30T15:31:35.939058',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 64.7148148148148,
        'condition_smartpo': {
          'id': '7c032330-7fca-4b3a-8517-4807df157011',
        },
        'domain_scores_smartpo': {
          'id': '53218590-1259-42d4-a0af-37267088adf6',
        },
        'pmq_smartpo': {
          'id': '9f989b2f-e98d-4320-b08a-7cd1ab3999c2',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'pmq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'pmq_score': 84.0,
          'pmq_created_time': '2024-04-30T15:31:35.941693',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '755296fc-c341-428a-9c9d-0e5bf5d72cd6',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'tug_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 13.0,
          'tug_created_time': '2024-04-30T15:31:35.941241',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': 'a3b659bd-59ac-4b6b-a93e-39689b0ef8ac',
          'hrqol_weight_val': 16.334661354581673,
          'function_weight_val': 20.318725099601593,
          'goals_weight_val': 26.693227091633464,
          'comfort_weight_val': 4.780876494023905,
          'satisfaction_weight_val': 31.872509960159363,
          '_creationTime': '2024-06-28T22:18:05.848Z',
          '_lastModifiedTime': '2024-06-28T22:18:05.848Z',
          '_caption': 'ja_dwd_current'
        },
        'fh_smartpo': {
          'id': '3d3ab35e-7b71-4d1f-88b7-55385272d4aa',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 1.0,
          'fh_created_time': '2024-04-30T15:31:35.941388',
          'fh_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': '5a3138ee-1960-4c73-af79-8c0922574d78',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 60.0,
          'eq5d_5l_created_time': '2024-04-30T15:31:35.941998',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': 'd5c23653-7100-44b8-b722-d9449ee33ed7',
        },
        'encounter_created_time_smartpo': '2024-04-30T15:33:13.086573',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': 'a819a7a4-580f-46f5-94c2-6b8b02270abe',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '3b888927-3ec5-410e-8b8d-493c2e305583',
              }
            }
          },
          'psq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 80.0,
          'psq_order': 1,
          'psq_created_time': '2024-04-30T15:31:35.939741',
        },
      },
      {
        '_name': 'ja_session_20240220_15:29:58',
        '_id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
        'promispi_smartpo': {
          'id': 'e475df00-88f8-441d-8613-5979988b7ca7',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'promispi_score': 72.0,
          'promispi_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'promispi_order': 3,
          'promispi_created_time': '2024-02-20T15:28:18.590179',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': 'ca0fea7f-5906-4b2e-b01c-8a441317b75f',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2024-02-20T15:28:18.589930',
          'scs_score': 2.0,
          'scs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '7facea7b-74bb-4e9d-8432-f882eedd2d76',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'psfs_score': 5.0,
          'psfs_created_time': '2024-02-20T15:28:18.586241',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 38.62962962962963,
        'condition_smartpo': {
          'id': '7c032330-7fca-4b3a-8517-4807df157011',
        },
        'domain_scores_smartpo': {
          'id': '39c5ef4c-2879-4b62-9ccc-5549cb7c4d65',
        },
        'pmq_smartpo': {
          'id': '35b2a263-aa9d-479e-8431-bbf0691df82a',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'pmq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'pmq_score': 28.0,
          'pmq_created_time': '2024-02-20T15:28:18.593047',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '41ff3b93-eb7e-4c09-b0fd-cc98e0b2a596',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'tug_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 18.0,
          'tug_created_time': '2024-02-20T15:28:18.590362',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': 'a3b659bd-59ac-4b6b-a93e-39689b0ef8ac',
          'hrqol_weight_val': 16.334661354581673,
          'function_weight_val': 20.318725099601593,
          'goals_weight_val': 26.693227091633464,
          'comfort_weight_val': 4.780876494023905,
          'satisfaction_weight_val': 31.872509960159363,
        },
        'fh_smartpo': {
          'id': 'd2bdb84b-5d44-4604-9d4a-90ef84280c51',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 2.0,
          'fh_created_time': '2024-02-20T15:28:18.590462',
          'fh_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': 'db40d1e0-5aa0-42df-8fb9-f14ee08c622e',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 40.0,
          'eq5d_5l_created_time': '2024-02-20T15:28:18.593209',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': 'd5c23653-7100-44b8-b722-d9449ee33ed7',
        },
        'encounter_created_time_smartpo': '2024-02-20T15:29:58.753461',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '5e0dace3-3fb5-426a-869d-a5dc8dfb2e1b',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'e3bc874f-f078-4aef-9639-e6ba7f5c9f28',
              }
            }
          },
          'psq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 60.0,
          'psq_order': 1,
          'psq_created_time': '2024-02-20T15:28:18.586708',
        },
      },
      {
        '_name': 'ja_session_20240110_15:22:54',
        '_id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
        'promispi_smartpo': {
          'id': 'e740d4e0-4349-4b61-a7cf-f70f76fa6d6f',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'promispi_score': 77.0,
          'promispi_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'promispi_order': 3,
          'promispi_created_time': '2024-01-10T15:21:28.145865',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': 'defe718c-6e43-4d7f-aacc-4e2bfc431487',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2024-01-10T15:21:28.144909',
          'scs_score': 0.0,
          'scs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': 'd6708ca8-f82b-4933-97d0-5dce9fff52ff',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'psfs_score': 0.0,
          'psfs_created_time': '2024-01-10T15:21:28.140997',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 19.466666666666665,
        'condition_smartpo': {
          'id': '7c032330-7fca-4b3a-8517-4807df157011',
        },
        'domain_scores_smartpo': {
          'id': 'd39493ef-4aff-47d3-833e-deddeea6507b',
        },
        'pmq_smartpo': {
          'id': '1aaa0046-7198-42a5-81aa-a1543835286d',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'pmq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'pmq_score': 0.0,
          'pmq_created_time': '2024-01-10T15:21:28.148409',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': 'cbb97555-53e6-434a-9efc-995000ddb402',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'tug_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 20.0,
          'tug_created_time': '2024-01-10T15:21:28.146570',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': 'a3b659bd-59ac-4b6b-a93e-39689b0ef8ac',
          'hrqol_weight_val': 16.334661354581673,
          'function_weight_val': 20.318725099601593,
          'goals_weight_val': 26.693227091633464,
          'comfort_weight_val': 4.780876494023905,
          'satisfaction_weight_val': 31.872509960159363,
        },
        'fh_smartpo': {
          'id': 'e437b61b-e93d-4e55-9779-5b3b98af862b',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 0.0,
          'fh_created_time': '2024-01-10T15:21:28.147058',
          'fh_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': '7ddb2384-5282-400a-984b-2c3dfb800394',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 15.0,
          'eq5d_5l_created_time': '2024-01-10T15:21:28.148859',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': 'd5c23653-7100-44b8-b722-d9449ee33ed7',
        },
        'encounter_created_time_smartpo': '2024-01-10T15:22:54.036272',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '8a480e52-12d0-4077-92b9-e90b682ef7ff',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'fae83346-dc8f-4ab4-b804-09a176bfe07f',
              }
            }
          },
          'psq_patient': {
            'id': '889ef81e-ccb5-48ee-b681-c4b1fa71f077',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 50.0,
          'psq_order': 1,
          'psq_created_time': '2024-01-10T15:21:28.142799',
        },
      }
    ],
    'domainScores': [
      {
        '_name': 'ja_dm_scores_20240628_154243',
        'function_domain_score': 81.66666666666666,
        'comfort_domain_score': 88.33333333333334,
        'satisfaction_domain_score': 20.0,
        'hrqol_domain_score': 82.0,
        'goals_domain_score': 90.0,
      },
      {
        '_name': 'ja_dm_scores_20240430_153317',
        'function_domain_score': 63.74074074074073,
        'comfort_domain_score': 60.83333333333333,
        'satisfaction_domain_score': 80.0,
        'hrqol_domain_score': 60.0,
        'goals_domain_score': 60.0,
      },
      {
        '_name': 'ja_dm_scores_20240220_153003',
        'function_domain_score': 27.481481481481477,
        'comfort_domain_score': 16.666666666666668,
        'satisfaction_domain_score': 60.0,
        'hrqol_domain_score': 40.0,
        'goals_domain_score': 50.0,
      },
      {
        '_name': 'ja_dm_scores_20240110_152258',
        'function_domain_score': 33.33333333333333,
        'comfort_domain_score': 0.0,
        'satisfaction_domain_score': 50.0,
        'hrqol_domain_score': 15.0,
        'goals_domain_score': 0.0,
      }
    ],
    'assistive_devices': [
      {
        '_id': '6d5daee3-52cd-4ad7-a444-d2544fd3ba5d',
        'device_name': 'test1',
        'amputee_side': 0,
        'l_code': 'L0001',
      }
    ]
  },
  {
    'patient_id': 'sm001',
    '_id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
    '_name': {'firstName': 'Sarah', 'lastName': 'Miller'},
    '_email': 'sm@sm.com',
    '_dateOfBirth': '1965-08-07',
    'sex_at_birth': 1,
    'current_sex': 1,
    'race': 4,
    'ethnicity': 1,
    'condition': {
      '_id': '7a9afebd-5c17-42a3-885b-26decc7937b2',
      'condition_type': ['prosthetic', 'lower'],
    },
    'k_level': {
      '_id': '0439ceb6-3b39-4ecc-9e83-480a32002062',
      'k_level': 1,
    },
    'encounters': [
      {
        '_name': 'ms_session_20240517_16:02:17',
        '_id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
        'promispi_smartpo': {
          'id': 'add9aadd-19ea-471d-8fe2-56a56683cad4',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'promispi_score': 42.0,
          'promispi_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'promispi_order': 3,
          'promispi_created_time': '2024-05-17T16:00:57.917862',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': '5a187097-e864-41cf-b01b-96d1e2bef2ef',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2024-05-17T16:00:57.917471',
          'scs_score': 10.0,
          'scs_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '060348b4-7a09-422e-adb1-e5f3b87fd44f',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'psfs_score': 10.0,
          'psfs_created_time': '2024-05-17T16:00:57.916580',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 93.93333333333334,
        'condition_smartpo': {
          'id': '7a9afebd-5c17-42a3-885b-26decc7937b2',
        },
        'domain_scores_smartpo': {
          'id': '6eb61cce-51c2-4781-beb6-40d38d03db20',
        },
        'pmq_smartpo': {
          'id': '42da135b-5d18-4e44-8817-d1d269c3d4c4',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'pmq_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'pmq_score': 95.0,
          'pmq_created_time': '2024-05-17T16:00:57.918725',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '60c5f41a-8e36-4359-8b82-e4ae43d0ab85',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'tug_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 9.0,
          'tug_created_time': '2024-05-17T16:00:57.918199',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '99ebdbca-10c7-4857-9857-fb9e82cf1076',
          'hrqol_weight_val': 29.788597053171046,
          'function_weight_val': 16.976297245355546,
          'goals_weight_val': 25.624599615631006,
          'comfort_weight_val': 6.47021140294683,
          'satisfaction_weight_val': 21.14029468289558,
        },
        'fh_smartpo': {
          'id': 'b22f48ef-7ae5-43db-92ae-9113f476219b',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 0.0,
          'fh_created_time': '2024-05-17T16:00:57.918349',
          'fh_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': '8d4b2903-f7ee-4336-85df-c02c6cbc8105',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 93.0,
          'eq5d_5l_created_time': '2024-05-17T16:00:57.918988',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '0439ceb6-3b39-4ecc-9e83-480a32002062',
        },
        'encounter_created_time_smartpo': '2024-05-17T16:02:17.750305',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': 'b83c1292-6a6e-4154-b351-3bad88fe1732',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '8c2a7cfb-41b0-4e80-82fc-62bee78a1179',
              }
            }
          },
          'psq_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 96.0,
          'psq_order': 1,
          'psq_created_time': '2024-05-17T16:00:57.917265',
        },
      },
      {
        '_name': 'ms_session_20231022_15:58:01',
        '_id': '051cb405-f776-4738-826c-031128a8e441',
        'promispi_smartpo': {
          'id': '3aa19878-2652-4831-be84-92c381ac7cca',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'promispi_score': 43.0,
          'promispi_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'promispi_order': 3,
          'promispi_created_time': '2023-10-22T15:56:47.049556',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': 'f105eabe-cfba-4c81-b70f-9448729d3f21',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2023-10-22T15:56:47.049076',
          'scs_score': 6.0,
          'scs_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '526ac5e2-0532-440e-81f5-16329c5c06c3',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'psfs_score': 8.0,
          'psfs_created_time': '2023-10-22T15:56:47.047953',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 80.34814814814816,
        'condition_smartpo': {
          'id': '7a9afebd-5c17-42a3-885b-26decc7937b2',
        },
        'domain_scores_smartpo': {
          'id': 'c69496f4-4b04-4420-9494-1842ef7fbc11',
        },
        'pmq_smartpo': {
          'id': 'f08e61bc-5023-49ab-8b1b-6637ebe16b65',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'pmq_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'pmq_score': 77.0,
          'pmq_created_time': '2023-10-22T15:56:47.050773',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': 'e437bff2-bfb9-404b-8973-c02fd097fa84',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'tug_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 9.0,
          'tug_created_time': '2023-10-22T15:56:47.050091',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '99ebdbca-10c7-4857-9857-fb9e82cf1076',
          'hrqol_weight_val': 29.788597053171046,
          'function_weight_val': 16.976297245355546,
          'goals_weight_val': 25.624599615631006,
          'comfort_weight_val': 6.47021140294683,
          'satisfaction_weight_val': 21.14029468289558,
        },
        'fh_smartpo': {
          'id': '6fe5c189-9301-47c7-a06f-7b560a1d59c2',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 1.0,
          'fh_created_time': '2023-10-22T15:56:47.050281',
          'fh_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': 'c0912b7f-cb67-4d8c-9aa3-82a26d1dda69',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 82.0,
          'eq5d_5l_created_time': '2023-10-22T15:56:47.051229',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '0439ceb6-3b39-4ecc-9e83-480a32002062',
        },
        'encounter_created_time_smartpo': '2023-10-22T15:58:01.585550',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': 'fc13c316-ff51-47b8-9681-313b556f33f4',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '051cb405-f776-4738-826c-031128a8e441',
              }
            }
          },
          'psq_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 96.0,
          'psq_order': 1,
          'psq_created_time': '2023-10-22T15:56:47.048699',
        },
      },
      {
        '_name': 'ms_session_20221105_15:55:05',
        '_id': '85b7e414-8838-475c-9fa2-c54e2690152b',
        'promispi_smartpo': {
          'id': '0aeaf3bb-24a8-421b-83af-6505eb9f4ab3',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'promispi_score': 44.0,
          'promispi_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'promispi_order': 3,
          'promispi_created_time': '2022-11-05T15:53:49.817581',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': '6c95eee3-199c-4d45-b3b6-79fb72f7aa42',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2022-11-05T15:53:49.814845',
          'scs_score': 10.0,
          'scs_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '39649310-af4c-4133-9172-e0c2a0712802',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'psfs_score': 10.0,
          'psfs_created_time': '2022-11-05T15:53:49.805371',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 91.17407407407408,
        'condition_smartpo': {
          'id': '7a9afebd-5c17-42a3-885b-26decc7937b2',
        },
        'domain_scores_smartpo': {
          'id': '226069fc-4cf8-4a81-91dc-2276ede43771',
        },
        'pmq_smartpo': {
          'id': 'ad5b1978-6902-46cc-af0c-022119f3cc34',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'pmq_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'pmq_score': 92.0,
          'pmq_created_time': '2022-11-05T15:53:49.819739',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '83d101b4-af76-4fde-b60a-f929f1979f4d',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'tug_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 10.0,
          'tug_created_time': '2022-11-05T15:53:49.818364',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '99ebdbca-10c7-4857-9857-fb9e82cf1076',
          'hrqol_weight_val': 29.788597053171046,
          'function_weight_val': 16.976297245355546,
          'goals_weight_val': 25.624599615631006,
          'comfort_weight_val': 6.47021140294683,
          'satisfaction_weight_val': 21.14029468289558,
        },
        'fh_smartpo': {
          'id': '4fce5a7b-1294-42dd-9d46-48929206c978',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 0.5,
          'fh_created_time': '2022-11-05T15:53:49.818781',
          'fh_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': 'de19e4bb-49ae-4746-b42e-89611a2efd26',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 90.0,
          'eq5d_5l_created_time': '2022-11-05T15:53:49.820402',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '0439ceb6-3b39-4ecc-9e83-480a32002062',
        },
        'encounter_created_time_smartpo': '2022-11-05T15:55:05.019808',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '99420d9d-ed48-4459-9af5-42813d11595f',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '85b7e414-8838-475c-9fa2-c54e2690152b',
              }
            }
          },
          'psq_patient': {
            'id': '7714b405-5183-4557-a15f-3c9bfd9e45d1',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 95.0,
          'psq_order': 1,
          'psq_created_time': '2022-11-05T15:53:49.808926',
        },
      }
    ],
    'domainScores': [
      {
        '_name': 'ms_dm_scores_20240517_160224',
        'function_domain_score': 83.33333333333331,
        'comfort_domain_score': 98.33333333333334,
        'satisfaction_domain_score': 96.0,
        'hrqol_domain_score': 93.0,
        'goals_domain_score': 100.0,
      },
      {
        '_name': 'ms_dm_scores_20231022_155805',
        'function_domain_score': 68.07407407407408,
        'comfort_domain_score': 76.66666666666666,
        'satisfaction_domain_score': 96.0,
        'hrqol_domain_score': 82.0,
        'goals_domain_score': 80.0,
      },
      {
        '_name': 'ms_dm_scores_20221105_155508',
        'function_domain_score': 76.03703703703704,
        'comfort_domain_score': 95.83333333333334,
        'satisfaction_domain_score': 95.0,
        'hrqol_domain_score': 90.0,
        'goals_domain_score': 100.0,
      }
    ],
    'assistive_devices': [
      {
        '_id': '6d5daee3-52cd-4ad7-a444-d2544fd3ba5d',
        'device_name': 'test1',
        'amputee_side': 0,
        'l_code': 'L0001',
      }
    ]
  },
  {
    'patient_id': 'mt001',
    '_id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
    '_name': {'firstName': 'Michael', 'lastName': 'Thompson'},
    '_email': 'mt@mt.com',
    '_dateOfBirth': '1965-08-07',
    'sex_at_birth': 0,
    'current_sex': 0,
    'race': 4,
    'ethnicity': 1,
    'condition': {
      '_id': 'eeaacda8-d168-44d5-9056-7fe0d2b16aed',
      'condition_type': ['prosthetic', 'lower'],
    },
    'k_level': {
      '_id': '08a13005-8aeb-4a47-8c9a-faaf5030a0dd',
      'k_level': 1,
    },
    'encounters': [
      {
        '_name': 'tm_session_20230330_14:06:15',
        '_id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
        'promispi_smartpo': {
          'id': '11160734-e411-4c26-a0a3-10f6fd3ff5ff',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'promispi_score': 48.0,
          'promispi_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'promispi_order': 3,
          'promispi_created_time': '2023-03-30T14:04:58.715861',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': 'b0f8e6dd-4fad-4709-9ae4-1e5fc2665a85',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2023-03-30T14:04:58.715438',
          'scs_score': 9.0,
          'scs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '1f4c7eaf-8334-4722-8415-23056d29c608',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'psfs_score': 9.0,
          'psfs_created_time': '2023-03-30T14:04:58.714505',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 84.74814814814815,
        'condition_smartpo': {
          'id': 'eeaacda8-d168-44d5-9056-7fe0d2b16aed',
        },
        'domain_scores_smartpo': {
          'id': 'e905770a-29b7-487c-b53b-9b86917d6b88',
        },
        'pmq_smartpo': {
          'id': '8c82ed6b-ab2a-4ab8-96bc-7e9311b02c3d',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'pmq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'pmq_score': 90.0,
          'pmq_created_time': '2023-03-30T14:04:58.716670',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '0407756e-890a-48db-8073-e1f97d5301cd',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'tug_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 10.0,
          'tug_created_time': '2023-03-30T14:04:58.716196',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '4eca74c4-92d8-44db-8469-dc9c1f8f5125',
          'hrqol_weight_val': 25.0,
          'function_weight_val': 20.33898305084746,
          'goals_weight_val': 9.322033898305085,
          'comfort_weight_val': 32.20338983050847,
          'satisfaction_weight_val': 13.135593220338984,
        },
        'fh_smartpo': {
          'id': 'bd5a4d33-82f5-4c38-9968-2c6bcba5b51e',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 1.0,
          'fh_created_time': '2023-03-30T14:04:58.716353',
          'fh_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': 'bcb8863f-0f2e-4e36-94f4-2dbb23091aff',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 81.0,
          'eq5d_5l_created_time': '2023-03-30T14:04:58.716905',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '08a13005-8aeb-4a47-8c9a-faaf5030a0dd',
        },
        'encounter_created_time_smartpo': '2023-03-30T14:06:15.168504',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '3a9cd668-b425-4c38-a6df-ba72a9b7aae7',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '03e47b9c-3b90-4e6a-9535-652cb288d765',
              }
            }
          },
          'psq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 98.0,
          'psq_order': 1,
          'psq_created_time': '2023-03-30T14:04:58.715207',
        },
      },
      {
        '_name': 'tm_session_20220712_14:03:37',
        '_id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
        'promispi_smartpo': {
          'id': '6374b672-9773-48af-96d9-840a3eb59811',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'promispi_score': 74.0,
          'promispi_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'promispi_order': 3,
          'promispi_created_time': '2022-07-12T14:02:21.669154',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': 'b248e16a-5bf9-43bf-82cf-5c3159710819',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2022-07-12T14:02:21.668696',
          'scs_score': 2.0,
          'scs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': 'c922967b-1d8f-45ea-a1e6-c62aaf4d2160',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'psfs_score': 6.0,
          'psfs_created_time': '2022-07-12T14:02:21.667613',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 51.97777777777778,
        'condition_smartpo': {
          'id': 'eeaacda8-d168-44d5-9056-7fe0d2b16aed',
        },
        'domain_scores_smartpo': {
          'id': '00e368f0-2ccd-4a01-8dce-84b10ac34584',
        },
        'pmq_smartpo': {
          'id': '07b61305-3e65-467b-bae9-083a5c83064c',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'pmq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'pmq_score': 75.0,
          'pmq_created_time': '2022-07-12T14:02:21.670121',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '6681a85e-dbfc-4bf0-9d82-38a7b73e0cc5',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'tug_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 18.0,
          'tug_created_time': '2022-07-12T14:02:21.669639',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '4eca74c4-92d8-44db-8469-dc9c1f8f5125',
          'hrqol_weight_val': 25.0,
          'function_weight_val': 20.33898305084746,
          'goals_weight_val': 9.322033898305085,
          'comfort_weight_val': 32.20338983050847,
          'satisfaction_weight_val': 13.135593220338984,
        },
        'fh_smartpo': {
          'id': '1894e597-d9bb-47ac-b783-58f01e35ba31',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 3.0,
          'fh_created_time': '2022-07-12T14:02:21.669821',
          'fh_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': '338a10ec-8344-480a-a471-57ff67b86afd',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 60.0,
          'eq5d_5l_created_time': '2022-07-12T14:02:21.670424',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '08a13005-8aeb-4a47-8c9a-faaf5030a0dd',
        },
        'encounter_created_time_smartpo': '2022-07-12T14:03:37.704929',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '3cf7c44b-2b27-4397-a667-ec1fa0cb2a7a',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '2846e68c-e5ea-4cd2-9970-1d0f974bb7d0',
              }
            }
          },
          'psq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 92.0,
          'psq_order': 1,
          'psq_created_time': '2022-07-12T14:02:21.668401',
        },
      },
      {
        '_name': 'tm_session_20200410_14:00:07',
        '_id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
        'promispi_smartpo': {
          'id': '4b8f27c0-d43e-435f-8bbf-03c7aadef56c',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'promispi_score': 64.0,
          'promispi_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'promispi_order': 3,
          'promispi_created_time': '2020-04-10T13:58:31.856605',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': 'd9126b89-1b1b-4cca-b27b-0f470c6f6971',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2020-04-10T13:58:31.856032',
          'scs_score': 8.0,
          'scs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '164d94e9-a2c1-43c6-86a1-85d18fe9b263',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'psfs_score': 8.0,
          'psfs_created_time': '2020-04-10T13:58:31.852396',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 72.59629629629629,
        'condition_smartpo': {
          'id': 'eeaacda8-d168-44d5-9056-7fe0d2b16aed',
        },
        'domain_scores_smartpo': {
          'id': '6409f2b6-0859-4e47-ae84-6a088e520203',
        },
        'pmq_smartpo': {
          'id': '9f087bd9-da70-4c74-be80-5d4d2c652604',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'pmq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'pmq_score': 93.0,
          'pmq_created_time': '2020-04-10T13:58:31.866743',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '19663e46-2c55-48b0-8eff-5e67db2d9258',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'tug_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 13.0,
          'tug_created_time': '2020-04-10T13:58:31.862597',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '4eca74c4-92d8-44db-8469-dc9c1f8f5125',
          'hrqol_weight_val': 25.0,
          'function_weight_val': 20.33898305084746,
          'goals_weight_val': 9.322033898305085,
          'comfort_weight_val': 32.20338983050847,
          'satisfaction_weight_val': 13.135593220338984,
        },
        'fh_smartpo': {
          'id': 'f6adbccd-e7a5-4335-b18d-abb518370f10',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 2.0,
          'fh_created_time': '2020-04-10T13:58:31.865782',
          'fh_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': '3512ad36-ce0c-42f9-b9ee-fce91f300f58',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 74.0,
          'eq5d_5l_created_time': '2020-04-10T13:58:31.867398',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '08a13005-8aeb-4a47-8c9a-faaf5030a0dd',
        },
        'encounter_created_time_smartpo': '2020-04-10T14:00:07.763801',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '4bb4819e-6012-444b-9bd6-99993731a5ae',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '73a272dc-993a-4ea6-8e89-444a7c770ed1',
              }
            }
          },
          'psq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 95.0,
          'psq_order': 1,
          'psq_created_time': '2020-04-10T13:58:31.855231',
        },
      },
      {
        '_name': 'tm_session_20190620_13:49:22',
        '_id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
        'promispi_smartpo': {
          'id': '97e6a63a-ad00-42ec-a8ce-cdc333430912',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'promispi_score': 62.0,
          'promispi_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'promispi_order': 3,
          'promispi_created_time': '2019-06-20T13:48:04.167176',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': '03c7426e-2824-435b-b035-dc8f56ce6214',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2019-06-20T13:48:04.167019',
          'scs_score': 6.0,
          'scs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': 'fd5c5b49-6a81-4837-aafa-9284c06366c9',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'psfs_score': 5.0,
          'psfs_created_time': '2019-06-20T13:48:04.165522',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 55.033333333333324,
        'condition_smartpo': {
          'id': 'eeaacda8-d168-44d5-9056-7fe0d2b16aed',
        },
        'domain_scores_smartpo': {
          'id': 'bb171734-9fc7-47fc-8713-22d441e16ce8',
        },
        'pmq_smartpo': {
          'id': 'a3544516-cebb-4d40-a0a8-454ab49ecdd5',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'pmq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'pmq_score': 84.0,
          'pmq_created_time': '2019-06-20T13:48:04.167673',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': '918af858-946d-4fb5-ab3a-3b7734d22ee6',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'tug_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 15.0,
          'tug_created_time': '2019-06-20T13:48:04.167419',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '4eca74c4-92d8-44db-8469-dc9c1f8f5125',
          'hrqol_weight_val': 25.0,
          'function_weight_val': 20.33898305084746,
          'goals_weight_val': 9.322033898305085,
          'comfort_weight_val': 32.20338983050847,
          'satisfaction_weight_val': 13.135593220338984,
        },
        'fh_smartpo': {
          'id': '4f92b8c5-82b9-4585-a0a2-07b57fbe2328',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 4.0,
          'fh_created_time': '2019-06-20T13:48:04.167497',
          'fh_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': 'b19d8cd8-95a3-4857-bd56-aa84afab87e8',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 50.0,
          'eq5d_5l_created_time': '2019-06-20T13:48:04.167900',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '08a13005-8aeb-4a47-8c9a-faaf5030a0dd',
        },
        'encounter_created_time_smartpo': '2019-06-20T13:49:22.849786',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': '305c9044-0bd0-42c7-82ff-606d5291be04',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': 'fe85fc22-d656-4c9b-ad01-2100e975b7c7',
              }
            }
          },
          'psq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 89.0,
          'psq_order': 1,
          'psq_created_time': '2019-06-20T13:48:04.166671',
        },
      },
      {
        '_name': 'tm_session_20190305_13:41:23',
        '_id': '99be1c9f-0022-4953-8c51-4cc395219e55',
        'promispi_smartpo': {
          'id': '59f410ed-52a3-4dbe-9b29-38fadef4ae42',
          '_referencers': {
            'promispi_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'promispi_score': 76.0,
          'promispi_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'promispi_order': 3,
          'promispi_created_time': '2019-03-05T13:40:02.141434',
          'promispi_raw_data': jsonEncode({'.': '.'}),
        },
        'scs_smartpo': {
          'id': '1b15b6a2-5b31-4521-b539-cace4509671f',
          '_referencers': {
            'scs_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'scs_raw_data': jsonEncode({'.': '.'}),
          'scs_created_time': '2019-03-05T13:40:02.137263',
          'scs_score': 0.0,
          'scs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'scs_order': 2,
        },
        'psfs_smartpo': {
          'id': '94774892-9610-4fb2-b5c5-7d87e9804354',
          '_referencers': {
            'psfs_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'psfs_score': 0.0,
          'psfs_created_time': '2019-03-05T13:40:02.129165',
          'psfs_order': 0,
          'psfs_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psfs_raw_data': jsonEncode({'.': '.'}),
        },
        'total_score_smartpo': 35.148148148148145,
        'condition_smartpo': {
          'id': 'eeaacda8-d168-44d5-9056-7fe0d2b16aed',
        },
        'domain_scores_smartpo': {
          'id': 'a2ad9583-ee8a-41b6-83b5-6751e37719e8',
        },
        'pmq_smartpo': {
          'id': '84e0b646-7da9-4438-bc83-4be24882f176',
          '_referencers': {
            'pmq_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'pmq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'pmq_score': 72.0,
          'pmq_created_time': '2019-03-05T13:40:02.143814',
          'pmq_raw_data': jsonEncode({'.': '.'}),
          'pmq_order': 6,
        },
        'tug_smartpo': {
          'id': 'b1b10d00-d8ae-4057-8be2-045646706406',
          '_referencers': {
            'tug_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'tug_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'tug_raw_data': jsonEncode({'.': '.'}),
          'tug_elapsed_time': 20.0,
          'tug_created_time': '2019-03-05T13:40:02.142366',
          'tug_order': 4,
        },
        'domain_weight_distribution_smartpo': {
          'id': '4eca74c4-92d8-44db-8469-dc9c1f8f5125',
          'hrqol_weight_val': 25.0,
          'function_weight_val': 20.33898305084746,
          'goals_weight_val': 9.322033898305085,
          'comfort_weight_val': 32.20338983050847,
          'satisfaction_weight_val': 13.135593220338984,
        },
        'fh_smartpo': {
          'id': 'dda5c7a6-d4ac-42c6-9bd3-a65d6a8f65e1',
          '_referencers': {
            'fh_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'fh_raw_data': jsonEncode({'.': '.'}),
          'falls_per_week': 1.0,
          'fh_created_time': '2019-03-05T13:40:02.142961',
          'fh_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'fh_order': 5,
        },
        'eq5d_5l_smartpo': {
          'id': '5c801949-647a-4ff7-b3b5-53fd3d61c5de',
          '_referencers': {
            'eq5d_5l_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'eq5d_5l_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'eq5d_5l_raw_data': jsonEncode({'.': '.'}),
          'eq5d_5l_health_score': 45.0,
          'eq5d_5l_created_time': '2019-03-05T13:40:02.144736',
          'eq5d_5l_order': 7,
        },
        'k_level_smartpo': {
          'id': '08a13005-8aeb-4a47-8c9a-faaf5030a0dd',
        },
        'encounter_created_time_smartpo': '2019-03-05T13:41:23.272770',
        'outcome_measures': 'psfs, psq, scs, promispi, tug, fh, pmq, eq5d_5l',
        'psq_smartpo': {
          'id': 'f265a5c9-9b95-4bfa-ae8a-1da79588c933',
          '_referencers': {
            'psq_smartpo': {
              'referrer': {
                'id': '99be1c9f-0022-4953-8c51-4cc395219e55',
              }
            }
          },
          'psq_patient': {
            'id': '2b5608cf-083e-432c-b3d4-f8de11d49dae',
          },
          'psq_raw_data': jsonEncode({'.': '.'}),
          'psq_score': 82.0,
          'psq_order': 1,
          'psq_created_time': '2019-03-05T13:40:02.132011',
        },
      }
    ],
    'domainScores': [
      {
        '_name': 'tm_dm_scores_20230330_140619',
        'function_domain_score': 70.74074074074073,
        'comfort_domain_score': 85.0,
        'satisfaction_domain_score': 98.0,
        'hrqol_domain_score': 81.0,
        'goals_domain_score': 90.0,
      },
      {
        '_name': 'tm_dm_scores_20220712_140341',
        'function_domain_score': 33.888888888888886,
        'comfort_domain_score': 14.1322314,
        'satisfaction_domain_score': 92.0,
        'hrqol_domain_score': 60.0,
        'goals_domain_score': 60.0,
      },
      {
        '_name': 'tm_dm_scores_20200410_140011',
        'function_domain_score': 57.48148148148148,
        'comfort_domain_score': 57.5,
        'satisfaction_domain_score': 95.0,
        'hrqol_domain_score': 74.0,
        'goals_domain_score': 80.0,
      },
      {
        '_name': 'tm_dm_scores_20190620_134926',
        'function_domain_score': 36.33333333333333,
        'comfort_domain_score': 50.83333333333333,
        'satisfaction_domain_score': 89.0,
        'hrqol_domain_score': 50.0,
        'goals_domain_score': 50.0,
      },
      {
        '_name': 'tm_dm_scores_20190305_134127',
        'function_domain_score': 48.07407407407407,
        'comfort_domain_score': 1.377410468,
        'satisfaction_domain_score': 82.0,
        'hrqol_domain_score': 45.0,
        'goals_domain_score': 0.0,
      }
    ],
    'assistive_devices': [
      {
        '_id': '6d5daee3-52cd-4ad7-a444-d2544fd3ba5d',
        'device_name': 'test1',
        'amputee_side': 0,
        'l_code': 'L0001',
      }
    ]
  },
];
