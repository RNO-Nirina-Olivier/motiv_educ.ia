import 'package:flutter/material.dart';
import 'package:motiv_educ/core/constants/app_constants.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialiser la valeur d'affichage
    _updateDisplayValue();
  }

  void _updateDisplayValue() {
    final currentValue = widget.controller.text;
    if (currentValue.isNotEmpty) {
      // Convertir "0/1" → "Non/Oui" pour l'affichage
      final mapping = AppConstants.featureValueMapping[widget.feature];
      if (mapping != null) {
        // Trouver la clé correspondant à la valeur
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
            
            // Indication de l'encodage
            if (widget.options != null && widget.feature != 'Ran_TbB' && widget.feature != 'nbre_elev_SDC')
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 12),
            
            // Champ de saisie
            if (widget.options != null && widget.options!.isNotEmpty)
              _buildDropdownField()
            else
              _buildTextField(),
            
            // Afficher la valeur encodée
            if (_selectedDisplayValue != null && widget.feature != 'Ran_TbB' && widget.feature != 'nbre_elev_SDC')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getEncodedValue(String displayValue) {
    final mapping = AppConstants.featureValueMapping[widget.feature];
    if (mapping != null && mapping.containsKey(displayValue)) {
      return mapping[displayValue]!;
    }
    return displayValue;
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Entrez la valeur...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _selectedDisplayValue = value;
        });
        if (widget.onChanged != null) widget.onChanged!(value);
      },
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
          });
          
          // Convertir la valeur d'affichage en valeur encodée
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