import 'package:flutter/material.dart';
import 'package:motiv_educ/core/constants/app_constants.dart';
import 'package:motiv_educ/data/models/student_model.dart';

class FeatureCard extends StatefulWidget {
  final String feature;
  final String description;
  final TextEditingController controller;
  final List<String>? options;
  final Function(String?)? onChanged;

  const FeatureCard({
    super.key,
    required this.feature,
    required this.description,
    required this.controller,
    this.options,
    this.onChanged,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  String? _selectedDisplayValue;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _updateDisplayValue();
  }

  void _updateDisplayValue() {
    final currentValue = widget.controller.text;
    if (currentValue.isNotEmpty) {
      // Cas spécial pour Ran_TbB (position dans la salle)
      if (widget.feature == 'Ran_TbB') {
        final position = RangPosition.fromValue(int.tryParse(currentValue));
        if (position != null) {
          setState(() {
            _selectedDisplayValue = position.label;
          });
        } else {
          setState(() {
            _selectedDisplayValue = currentValue;
          });
        }
        return;
      }
      
      // Pour les autres features avec mapping
      final mapping = AppConstants.featureValueMapping[widget.feature];
      if (mapping != null) {
        for (final entry in mapping.entries) {
          if (entry.value == currentValue) {
            setState(() {
              _selectedDisplayValue = entry.key;
            });
            return;
          }
        }
      }
      setState(() {
        _selectedDisplayValue = currentValue;
      });
    }
  }

  String? _validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    
    // Validation spéciale pour Ran_TbB
    if (widget.feature == 'Ran_TbB') {
      final intValue = int.tryParse(value);
      if (intValue == null) {
        return 'Veuillez entrer un nombre';
      }
      if (!RangPosition.valuesList.contains(intValue)) {
        return 'La position doit être 1 (Devant), 2 (Milieu) ou 3 (Fond)';
      }
      return null;
    }
    
    return null;
  }

  String _getEncodedValue(String displayValue) {
    // Cas spécial pour Ran_TbB
    if (widget.feature == 'Ran_TbB') {
      final position = RangPosition.fromLabel(displayValue);
      return position?.value.toString() ?? displayValue;
    }
    
    // Pour les autres features
    final mapping = AppConstants.featureValueMapping[widget.feature];
    if (mapping != null && mapping.containsKey(displayValue)) {
      return mapping[displayValue]!;
    }
    return displayValue;
  }

  String _getDisplayHint() {
    if (widget.feature == 'Ran_TbB') {
      return 'Ex: 1 = Devant, 2 = Milieu, 3 = Fond';
    }
    return 'Entrez la valeur...';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              widget.description,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            
            // Indication d'encodage pour Ran_TbB
            if (widget.feature == 'Ran_TbB')
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Encodage: 1 = Devant, 2 = Milieu, 3 = Fond',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 12),
            
            // Champ de saisie
            if (widget.options != null && widget.options!.isNotEmpty && widget.feature != 'Ran_TbB')
              _buildDropdownField()
            else if (widget.feature == 'Ran_TbB')
              _buildRanTbBField()
            else
              _buildTextField(),
            
            // Message d'erreur
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            
            // Afficher la valeur actuelle
            if (widget.controller.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Valeur encodée: ${widget.controller.text}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRanTbBField() {
    final currentValue = int.tryParse(widget.controller.text);
    final selectedLabel = RangPosition.fromValue(currentValue)?.label ?? 
                         (widget.controller.text.isNotEmpty ? widget.controller.text : null);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedLabel,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Sélectionnez la position...',
          ),
          items: RangPosition.labels.map((label) {
            return DropdownMenuItem<String>(
              value: label,
              child: Row(
                children: [
                  _getPositionIcon(label),
                  const SizedBox(width: 8),
                  Text(label),
                  const SizedBox(width: 8),
                  Text(
                    '(${_getPositionValue(label)})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (displayValue) {
            if (displayValue != null) {
              setState(() {
                _selectedDisplayValue = displayValue;
                _errorMessage = null;
              });
              
              final encodedValue = _getEncodedValue(displayValue);
              widget.controller.text = encodedValue;
              
              if (widget.onChanged != null) {
                widget.onChanged!(encodedValue);
              }
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner une position';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        // Affichage des options disponibles
        Wrap(
          spacing: 8,
          children: RangPosition.labels.map((label) {
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDisplayValue = label;
                  _errorMessage = null;
                });
                final encodedValue = _getEncodedValue(label);
                widget.controller.text = encodedValue;
                if (widget.onChanged != null) {
                  widget.onChanged!(encodedValue);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selectedLabel == label 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getPositionIcon(label, 
                        color: selectedLabel == label ? Colors.white : null),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedLabel == label ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getPositionIcon(String label, {Color? color}) {
    IconData icon;
    switch (label) {
      case 'Devant':
        icon = Icons.trending_up;
        break;
      case 'Milieu':
        icon = Icons.horizontal_rule;
        break;
      case 'Fond':
        icon = Icons.trending_down;
        break;
      default:
        icon = Icons.help_outline;
    }
    return Icon(icon, size: 16, color: color);
  }

  String _getPositionValue(String label) {
    switch (label) {
      case 'Devant':
        return '1';
      case 'Milieu':
        return '2';
      case 'Fond':
        return '3';
      default:
        return '';
    }
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: _getDisplayHint(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        helperText: widget.feature == 'Ran_TbB' ? 'Entrez 1, 2 ou 3' : null,
      ),
      onChanged: (value) {
        setState(() {
          _selectedDisplayValue = value;
          _errorMessage = _validateValue(value);
        });
        
        if (_errorMessage == null && widget.onChanged != null) {
          widget.onChanged!(value);
        } else if (widget.onChanged != null) {
          widget.onChanged!(null);
        }
      },
      validator: (value) => _validateValue(value),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedDisplayValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: widget.options!.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (displayValue) {
        if (displayValue != null) {
          setState(() {
            _selectedDisplayValue = displayValue;
            _errorMessage = null;
          });
          
          final encodedValue = _getEncodedValue(displayValue);
          widget.controller.text = encodedValue;
          
          if (widget.onChanged != null) {
            widget.onChanged!(encodedValue);
          }
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner une option';
        }
        return null;
      },
      hint: const Text('Sélectionnez...'),
    );
  }
}